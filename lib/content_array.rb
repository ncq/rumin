# coding: utf-8
require 'buffer'
require 'content'
require 'utf8_util'
require 'color_map'
class ContentArray < Content
  attr_reader :content, :color_map, :last_match

  # 配列の添字が行、各行は文字列
  # rubyでは文字列に対して配列のような位置を指定した操作ができる
  def initialize(content = '')
    if content.is_a?(Array)
      @content = content
    else
      @content = [content]
    end
    @color_map  = ColorMap.new(@content)
    @last_match = nil
  end

  def get_char(row, col)
    return nil if @content[row].nil?
    @content[row][col]
  end

  def get_string(row, col, count)
    return nil if count == 0
    return nil if @content[row].nil?
    @content[row][col, count]
  end

  def get_line(row)
    @content[row]
  end

  def get_color_map
    @color_map.color_map
  end

  def rows
    @content.size
  end

  def insert_char(char, row, col)
    before_change
    line = add_multi_char(char, row, col)
    return nil if line.nil?
    @content[row] = line
    line
  end

  def insert_string(str, row, col)
    before_change
    line = add_multi_char(str, row, col)
    return nil if line.nil?
    @content[row] = line
    line
  end

  def change_line(row, col)
    before_change
    line = get_line(row)
    return false if line.nil?
    return false if col > line.length
    line1 = line[0, col]
    line2 = line[col, (line.length - col)]
    @content[row] = line1
    @content[(row + 1), 0] = line2
    @color_map.change_line(row, col)
    true
  end

  def delete_line(row)
    before_change
    return false if row >= @content.size
    line1 = @content[0, row]
    line2 = @content[(row + 1), (@content.size - row - 1)]
    @content = line1 + line2
    @content = [''] if @content.size == 0
    @color_map.delete_line(row)
    true
  end

  def replace_line(row, line)
    return false if row >= @content.size
    @content[row] = line
    @color_map.delete_line(row)
    @color_map.add(0, row, 0, row, (line.length - 1))
    true
  end

  def to_string
    @content.join("\n")
  end

  def delete_char(count, row, col)
    before_change
    return nil if count == 0
    return nil if row > @content.size
    line = get_line(row)
    # 0より小さくなる場合は0になるように補正する
    if (count < 0 && (col + count) < 0)
      count = col * -1
    end
    line_1 = line[0, col]
    line_2 = line[col, (line.length - col)]
    if count < 0
      line_1 = line_1[0, (col + count)]
    else
      line_2 = line_2[count, (line_2.length - count)]
    end
    @content[row] = line_1 + line_2
    if count > 0
      @color_map.delete(row, col, row, (col + count - 1))
    else
      @color_map.delete(row, (col + count), row, (col - 1))
    end
    @content[row]
  end

  def delete_all
    @content   = ['']
    @color_map = ColorMap.new(@content)
  end

  def merge_line(count, row)
    before_change
    # implement minus direction only
    return if count > 0
    new_row = row + count
    return if new_row < 0
    merge_line = @content[(new_row + 1), count.abs].join("")
    @content[new_row] << merge_line
    content_1 = @content[0, (new_row + 1)]
    content_2 = @content[(row + 1), (@content.size - content_1.size + count)]
    @content = content_1 + content_2
    @color_map.merge_line(count, row)
    @content
  end

  def convert_col_point_into_cursor(row, col, cols)
    converter = create_point_cursor_col_converter(row, col, cols, true)
    return nil if converter.nil?
    converter[col]
  end

  def convert_col_cursor_into_point(row, col, cursor_col, cols)
    converter = create_point_cursor_col_converter(row, col, cols, false)
    return nil if converter.nil?
    converter[cursor_col]
  end

  def adjust_cursor_col(row, col, cols)
    line = get_line(row)
    return 0 if line.nil?
    len  = line.length
    return 0 if len == 0
    converter = create_point_cursor_col_converter(row, len, cols, false)
    last_col  = converter.max[0]
    return last_col if col > last_col
    converter.key?(col) ? col : col - 1
  end

  def convert_row_point_into_cursor(last_row, cols)
    total = 0
    last_row.times do |row|
      line  = get_line(row)
      if line.nil? || line.length == 0
        total += 1
      else
        total += (line.length / cols).ceil
      end
    end
    return total
  end

  def search_forward(pattern, start_row, start_col)
    return nil if start_row >= @content.length
    unless @last_match.nil?
      @color_map.change(0, @last_match[:st_row], @last_match[:st_col],
                        @last_match[:ed_row], @last_match[:ed_col])
      @last_match = nil
    end
    subject = @content[start_row, (@content.length - start_row)]
    subject.each_with_index do |line, index|
      if index == 0
        next if line.length < start_col
        line = line[start_col, (line.length - start_col)]
        col = line.index(pattern)
        col = col + start_col unless col.nil?
      else
        col = line.index(pattern)
      end
      unless col.nil?
        row = index + start_row
        @color_map.change(1, row, col, row, (col + pattern.length - 1))
        @last_match = {st_row:row, st_col:col, ed_row:row, ed_col: (col + pattern.length - 1)}
        return {row:row, col:col}
      end
    end
    nil
  end

  def search_backward(pattern, start_row, start_col)
    return nil if start_row >= @content.length
    unless @last_match.nil?
      @color_map.change(0, @last_match[:st_row], @last_match[:st_col],
                        @last_match[:ed_row], @last_match[:ed_col])
      @last_match = nil
    end
    subject = @content[0, (start_row + 1)].reverse
    subject.each_with_index do |line, index|
      if index == 0
        next if line.length < start_col
        line = line[0, (start_col + 1)]
        col = line.rindex(pattern)
      else
        col = line.rindex(pattern)
      end
      unless col.nil?
        row = start_row - index
        @color_map.change(1, row, col, row, (col + pattern.length - 1))
        @last_match = {st_row:row, st_col:col, ed_row:row, ed_col: (col + pattern.length - 1)}
        return {row:row, col:col}
      end
    end
    nil
  end

  def change_color_map(code, st_row, st_col, ed_row, ed_col)
    @color_map.change(code, st_row, st_col, ed_row, ed_col)
  end

  private
  def add_multi_char(str, row, col)
    line   = get_line(row)
    return nil if line.nil?
    return nil if col > line.length
    line_1 = line[0, col]
    line_2 = line[col, (line.length - col)]
    line   = line_1 + str + line_2
    @color_map.add(0, row, col, row, (col + str.length - 1))
    line
  end

  def create_point_cursor_col_converter(row, col, cols, to_cursor)
    converter = {}
    cols      = cols - 1
    line      = get_line(row)
    cur       = 0
    cur_line  = 0
    return nil if line.nil?
    for i in 0...col do
      return nil if line[i].nil?
      if to_cursor
        converter[i] = cur
      else
        converter[cur] = i
      end
      step = Utf8Util::full_width?(line[i]) ? 2 : 1
      cur      += step
      cur_line += step
      # adjust point if last character of line is a double-byte
      if cur_line == cols && !line[i + 1].nil? && Utf8Util::full_width?(line[i + 1])
        cur += 1
      end
      cur_line = 0 if cur_line >= cols
    end
    if to_cursor
      converter[col] = cur
    else
      converter[cur] = col
    end
    converter
  end

  def before_change
    unless @last_match.nil?
      @color_map.change(0, @last_match[:st_row], @last_match[:st_col],
                        @last_match[:ed_row], @last_match[:ed_col])
      @last_match = nil
    end
  end
end
