require './mruby/content'
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
    @content[row][col]
  end

  def get_string(row, col, count)
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
    @content[row] = line
    line
  end

  def insert_string(str, row, col)
    line = add_multi_char(str, row, col)
    @content[row] = line
  end

  def add_line(row)
    @content[(row + 1), 0] = ''
  end

  def change_line(row, col)
    line   = get_line(row)
    line1 = line[0, col]
    line2 = line[col, (line.length - col)]
    @content[row] = line1
    @content[(row + 1), 0] = line2
  end

  def delete_line(row)
    @content.slice!(row)
    @content = [''] if @content.size == 0
  end

  def to_string
    @content.join("\n")
  end

  def delete_char(count, row, col)
    line = get_line(row)
    # 0より小さくなる場合は0になるように補正する
    if (col < 0 && (col + count) < 0)
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
  end

  def convert_point_to_cursor(row, col)
    converter = create_point_cursor_converter(row, col, true)
    converter[col]
  end

  def convert_cursor_to_point(row, col, cursor_col)
    converter = create_point_cursor_converter(row, col, false)
    converter[cursor_col]
  end

  def adjust_cursor_col(row, col)
    line      = get_line(row)
    len       = line.length
    return 0 if len == 0
    converter = create_point_cursor_converter(row, len, true)
    return (converter[len - 1] + 1) if col > converter[len - 1]
    # returnがないとエラーになるので
    return converter.include?(col) ? col : col - 1
  end

  private
  def add_multi_char(str, row, col)
    line   = get_line(row)
    line_1 = line[0, col]
    line_2 = line[col, (line.length - col)]
    line   = line_1 + str + line_2
  end

  def create_point_cursor_converter(row, col, to_cursor)
    converter = []
    line = get_line(row)
    cur  = 0
    for i in 0...col do
      if to_cursor
        converter[i] = cur
      else
        converter[cur] = i
      end
      if Utf8Util::multibyte?(line[i])
        cur += 2
      else
        cur += 1
      end
    end
    if to_cursor
      converter[col] = cur
    else
      converter[cur] = col
    end
    converter
  end

end
