class Command
  require './mruby/utf8_util'

  def evaluate(inputs, buffer)
    input = Utf8Util::convert_utf_code(inputs)
    if input == 10
      # enter key
      buffer.change_line
    elsif input == 127
      # delete key
      buffer.delete(-1);
    elsif input == 259
      # up
      buffer.move_line(-1)
    elsif input == 258
      # down
      buffer.move_line(1)
    elsif input == 260
      # left
      buffer.move_point(-1)
    elsif input == 261
      # right
      buffer.move_point(1)
    else
      # input character
      buffer.insert_char(input.chr)
    end
  end
end
