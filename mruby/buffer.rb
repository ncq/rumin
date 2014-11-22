class Buffer
  require './mruby/point'
  require './mruby/content'
  require './mruby/content_array'
  require './mruby/cursor'
  require './mruby/mark'

  attr_accessor :name, :is_modified
  attr_reader :start, :end, :file_name, :content, :num_chars, :num_lines, :point, :cursor, :clipboard, :copy_mark
  def initialize(name)
    @name = name
    # TODO:want to better content structure
    # switch ContentArray class
    @content = ContentArray.new
    @point = Point.new
    @cursor = Cursor.new
    @copy_mark = Mark.new(@point)
    @is_modified = false
    @num_chars = 0
    @num_lines = 1
    #@clipboard = nil
    @clipboard = ContentArray.new
  end

  def get_cursor_row
    @cursor.row
  end

  def get_cursor_col
    @cursor.col
  end

  def get_char
    @content.get_char(@point.row, @point.col)
  end

  def get_string(count)
    @content.get_string(@point.row, @point.col, count)
  end

  def get_content
    @content.to_string
  end

  def insert_char(char)
    @content.insert_char(char, @point.row, @point.col)
    move_point(1)
    @num_chars += 1
    @is_modified = true
    true
  end

  def insert_string(str)
    @content.insert_string(str, @point.row, @point.col)
    move_point(str.length)
    @num_chars += str.length
    @is_modified = true
    true
  end

  def delete(count)
    count = count.to_i
    if count < 0 && (@point.col - count.abs) < 0
      merge_line(-1)
    else
      delete_char(count)
    end
  end

  def modified?
    @is_modified
  end

  def move_point(count = 1)
    # not move if string not exist at destination
    col_p = @point.col + count
    line  = @content.get_line(@point.row)
    return @point.col if (col_p < 0 || col_p > line.length)
    @point.move_point(count)
    col_c = @content.convert_point_to_cursor(@point.row, @point.col)
    @cursor.set_position(@point.row, col_c)
    col_p
  end

  def move_line(count = 1)
    # not move if string not exist at destination
    row = @point.row + count
    return @point.row if (row < 0 || row > (@content.rows - 1))
    # move to line's last if row is bigger than line length
    line   = @content.get_line(row)
    length = line.nil? ? 0 : line.length
    # adjust difference between half-byte and full-byte
    cursor_col = @content.adjust_cursor_col(row, @cursor.col)
    @cursor.set_position(row, cursor_col)
    @point.set_point(row, @content.convert_cursor_to_point(row, length, cursor_col))
    row
  end

  def change_line()
    @content.change_line(@point.row, @point.col)
    @point.set_point((@point.row + 1), 0)
    @cursor.set_position(@point.row, @point.col)
    @num_lines += 1
  end

  def delete_line()
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.delete_line(@point.row)
    if @content.rows == 0
      @point.set_point(0, 0)
      @cursor.set_position(0, 0)
    else
      if @point.row >= @content.rows
        move_line(-1)
      else
        move_line(0)
      end
    end
    @num_lines -= 1 if @num_lines > 1
    @num_chars -= old_length
    true
  end

  private
  def delete_char(count)
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.delete_char(count, @point.row, @point.col)
    new_line   = @content.get_line(@point.row)
    diff = new_line.length - old_length
    @num_chars += diff
    move_point(diff)
    @is_modified = true
    true
  end

  def merge_line(count)
    return if (@point.row + count) < 0
    col = @content.get_line(@point.row + count).length
    @content.merge_line(count, @point.row)
    @point.set_point((@point.row + count), col)
    @cursor.set_position((@cursor.row + count), @content.convert_point_to_cursor(@point.row, col))
    @is_modified = true
    true
  end

=begin
  def copy_character
    @clipboard = get_char
  end

  def paste_character
    insert_char(@clipboard)
  end
=end

  def set_copy_mark
    @copy_mark.set_location(@point.row, @point.col)
  end

  def copy_string
    @clipboard.content[0] = @content.get_string(@copy_mark.location.row, @copy_mark.location.col, @content.get_line(@copy_mark.location.row).size - @copy_mark.location.col)
    for i in (@copy_mark.location.row + 1)...@point.row
      @clipboard.content[i] = @content.get_line(i)
    end
    @clipboard.content[point.row] = @content.get_string(@point.row, 0, @point.col)
    j = 1
    for i in 1...@clipboard.rows
      @clipboard.content.insert(j, "\n")
      j = j + 2
    end
  end

  def paste_string
    @content.insert_string(@clipboard.get_line(0), @point.row, @point.col)
    @point.move_point(@clipboard.get_line(0).length)
    for i in 1...(@clipboard.rows - 1)
      if @clipboard.get_line(i) == "\n"
        change_line
      else
        @content.content[@point.row] = @clipboard.get_line(i)
        @point.move_point(@clipboard.get_line(i).length)
      end
    end
    @content.insert_string(@clipboard.get_line(@clipboard.rows - 1), @point.row, @point.col)
    @point.move_point(@clipboard.get_line(@clipboard.rows - 1).length)
  end

end

