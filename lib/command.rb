# -*- coding: utf-8 -*-
class Command
  require 'utf8_util'
  require 'keybind'
  require 'keymap'
  def initialize
    load_command
    keymap = Keymap.new('./config/keymap.yml')
    @keybind = Keybind.new('./config/keyconfig.rb', keymap)
  end

  def evaluate(inputs, buffer)
    input = Utf8Util::convert_utf_code(inputs)
    if input == 1 # 'ctrl-a'でRumin終了
      0
    elsif @keybind.key?(input)
      @keybind.press(input, buffer)
      true
    else
      # input character
      buffer.insert_char(input.chr)
      buffer.display.echo.print_message(input.chr)
      true
    end
  end

  # commnad配下まとめてrequire
  def load_command
    # TODO: 再帰的に
    paths = ['./command', './command/plugin']
    paths.each do |path|
      pathname = Pathname.new(path)

      puts "!!!"
      puts pathname.realdirpath
      puts "!!!"

      # plugins配下をrequire
      Dir.foreach(pathname) do |file|
        if file =~ /\.rb\z/
          require pathname + file
        end
      end
    end
  end
end
