# -*- coding: utf-8 -*-
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


  # class << self
  #   # commnad配下まとめてrequire
  #   def load_command
  #     # TODO: ファイルからのパスにする
  #     path = './mruby/command/'
  #     # plugins配下をrequire
  #     Dir.foreach(path) do |file|
  #       if file =~ /\.rb\z/ then
  #         require path + file
  #       end
  #     end
  #   end
  # end

  # TODO: DSLで
  # def keymap
  #   {
  #     10 => "BufferCommand::change_line(buffer)", # enter
  #   }
  # end

  # def evaluate(inputs, buffer)
  #   `echo #{inputs} >> shibata.log`
  #   input = convert_utf_code(inputs)

  #   if keymap.key?(input)
  #     eval keymap[input]
  #   else
  #     # input character
  #     buffer.insert_char(input.chr)
  #   end
  # end


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

  # cursesとmrubyでutf8のコードの扱いが違うのでmruby用に変換する
  # 具体的にはcursesでは制御コード込みの各オクテットの10進数
  # mrubyでは制御コードを除いた全体の10進数
  def convert_utf_code(inputs)
    if inputs.size == 1
      input = inputs[0]
    elsif inputs.size == 2
      first  = inputs[0].to_s(2)[3,5]
      second = inputs[1].to_s(2)[2,6]
      input = "#{first}#{second}".to_i(2)
    elsif inputs.size == 3
      first  = inputs[0].to_s(2)[4,4]
      second = inputs[1].to_s(2)[2,6]
      third  = inputs[2].to_s(2)[2,6]
      input = "#{first}#{second}#{third}".to_i(2)
    elsif inputs.size == 4
      first  = inputs[0].to_s(2)[5,3]
      second = inputs[1].to_s(2)[2,6]
      third  = inputs[2].to_s(2)[2,6]
      force  = inputs[3].to_s(2)[2,6]
      input = "#{first}#{second}#{third}#{force}".to_i(2)
    end
    vector
  end

end

# TODO: initへ移行
# Command.load_command
