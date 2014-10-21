class Buffer
  require './mruby/point'
  require './mruby/content'
  require './mruby/content_array'

  attr_accessor :name, :is_modified
  attr_reader :start, :end, :file_name, :content, :num_chars, :num_lines, :point
  def initialize(name)
    @name = name
    # @contentはとりあえず一次元配列(より良い構造を考える)
    # @contentのデータ構造を切り替えやすいように別クラスにしておく
    @content = ContentArray.new
    @point = Point.new
    @is_modified = false
    @num_chars = 0
    @num_lines = 1
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
    # 移動先に文字がなければ行の末尾に移動する
    col  = @point.col + count
    line = @content.get_line(@point.row)
    return @point.col if (col < 0 || col > line.length)
    @point.move_point(count)
    col
  end

  def add_line()
    # 実際は改行コードが入ったときに呼び出す
    @content.add_line
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def change_line()
    @content.change_line(@point.row, @point.col)
    @point.set_point((@point.row + 1), 0)
    @num_lines += 1
  end

  def delete_line()
    old_line   = @content.get_line(@point.row)
    old_length = old_line.length
    @content.delete_line(@point.row)
    if @content.rows == 0
      row = 0
      col = 0
    else
      row      = @point.row
      row      = (@content.rows - 1) if @content.get_line(@point.row).nil?
      col      = @point.col
      new_line = @content.get_line(row)
      if new_line.nil?
        col = 0
      else
        col = new_line.length if new_line[col].nil?
      end
    end
    @point.set_point(row, col)
    @num_lines -= 1
    @num_chars -= old_length
    true
  end

  # private
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
    @is_modified = true
    true
  end
end
