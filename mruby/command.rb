class Command
  require './mruby/utf8_util'

  def evaluate(inputs, buffer)
    # 矢印キーはutf8ではないかも
    if arrow?(inputs)
      input = arrow_vector(inputs)
    else
      input = Utf8Util::convert_utf_code(inputs)
    end
    if input == 'up'
      buffer.move_line(-1)
    elsif input == 'down'
      buffer.move_line(1)
    elsif input == 'left'
      buffer.move_point(-1)
    elsif input == 'right'
      buffer.move_point(1)
    elsif input == 10
      # enter key
      buffer.change_line
    elsif input == 127
      # delete key
      buffer.delete(-1);
    else
      # input character
      buffer.insert_char(input.chr)
    end
  end

  def arrow?(inputs)
    # 矢印キーはutf8のコード体系と違う
    return false unless inputs.size == 3
    return false unless (inputs[0] == 27 && inputs[1] == 91)
    return false unless [65, 66, 67, 68].include?(inputs[2])
    true
  end

  def arrow_vector(inputs, validate = false)
    if validate
      return nil unless arrow?(inputs)
    end
    vector = nil
    case(inputs[2])
    when 65
      vector = 'up'
    when 66
      vector = 'down'
    when 67
      vector = 'right'
    when 68
      vector = 'left'
    end
    vector
  end
end
