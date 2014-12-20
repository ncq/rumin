# -*- coding: utf-8 -*-
class Command
  require './mruby/utf8_util'
  require './mruby/keybind'
  require './mruby/keymap'
  def initialize
    load_command
    keymap = Keymap.new('./mruby/config/keymap.yml')
    @keybind = Keybind.new('./mruby/config/keyconfig.rb', keymap)
  end

  def evaluate(inputs, buffer)
    input = Utf8Util::convert_utf_code(inputs)
    if @keybind.key?(input)
      @keybind.press(input, buffer)
    else
      # input character
      buffer.insert_char(input.chr)
      buffer.display.echo.print_message(input.chr)
    end
  end

  # commnad配下まとめてrequire
  def load_command
    # TODO: 再帰的に
    paths = ['./mruby/command/', './mruby/command/plugin/']
    paths.each do |path|
      # plugins配下をrequire
      Dir.foreach(path) do |file|
        if file =~ /\.rb\z/
          require path + file
        end
      end
    end
  end
end
