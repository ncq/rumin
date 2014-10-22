require './mruby/content'
class ContentArray < Content
  attr_accessor :content
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
  end

  def merge_line(count, row)
    # とりあえずマイナス方向のみ
    return if count > 0
    return if (row + count) < 0
    merge_line = @content[(row + count + 1), count.abs].join("")
    @content[row + count] << merge_line
    content_1 = @content[0, (row + count + 1)]
    content_2 = @content[(row + 1), (@content.size - content_1.size + count)]
    @content = content_1 + content_2
  end

  private
  def add_multi_char(str, row, col)
    line   = get_line(row)
    line_1 = line[0, col]
    line_2 = line[col, (line.length - col)]
    line   = line_1 + str + line_2
  end

end
