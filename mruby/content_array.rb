# coding: utf-8
require './mruby/buffer'
require './mruby/content'
require './mruby/utf8_util'
class ContentArray < Content
  attr_reader :content

  # 配列の添字が行、各行は文字列
  # rubyでは文字列に対して配列のような位置を指定した操作ができる
  def initialize(content = '')
    if content.is_a?(Array)
      @content = content
    else
      @content = [content]
    end
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

  def rows
    @content.size
  end

  def insert_char(char, row, col)
    line = add_multi_char(char, row, col)
    return nil if line.nil?
    @content[row] = line
    line
  end

  def insert_string(str, row, col)
    line = add_multi_char(str, row, col)
    return nil if line.nil?
    @content[row] = line
    line
  end

  def change_line(row, col)
    line   = get_line(row)
    return false if line.nil?
    return false if col > line.length
    line1 = line[0, col]
    line2 = line[col, (line.length - col)]
    @content[row] = line1
    @content[(row + 1), 0] = line2
    true
  end

  def delete_line(row)
    return false if row >= @content.size
    line1 = @content[0, row]
    line2 = @content[(row + 1), (@content.size - row - 1)]
    @content = line1 + line2
    @content = [''] if @content.size == 0
    true
  end

  def replace_line(row, line)
    return false if row >= @content.size
    @content[row] = line
    true
  end

  def to_string
    @content.join("\n")
  end

  def delete_char(count, row, col)
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
    @content[row]
  end

  def merge_line(count, row)
    # とりあえずマイナス方向のみ
    return if count > 0
    new_row = row + count
    return if new_row < 0
    merge_line = @content[(new_row + 1), count.abs].join("")
    @content[new_row] << merge_line
    content_1 = @content[0, (new_row + 1)]
    content_2 = @content[(row + 1), (@content.size - content_1.size + count)]
    @content = content_1 + content_2
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

  private
  def add_multi_char(str, row, col)
    line   = get_line(row)
    return nil if line.nil?
    return nil if col > line.length
    line_1 = line[0, col]
    line_2 = line[col, (line.length - col)]
    line   = line_1 + str + line_2
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
end
