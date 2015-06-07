# -*- coding: utf-8 -*-
class Command
  require 'yaml'
  require 'utf8_util'
  require 'keybind'
  require 'keymap'

  def initialize
    load_command
    keymap = Keymap.new(File.expand_path('../config/keymap.yml', __FILE__))
    @keybind = Keybind.new(File.expand_path('../config/keyconfig.rb', __FILE__), keymap)
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
      # TODO implement echo
      # buffer.display.echo.print_message(input.chr)
      true
    end
  end

  # commnad配下まとめてrequire
  def load_command
    # TODO: 再帰的に
    paths = ['./command', './command/plugin']
    paths.each do |path|
      Dir.glob(File.expand_path(path, __FILE__) + "/*.rb").each do |file|
        puts file
      end

      # Dir.glob(File.expand_path(path) + "/*.rb").each do |file|
      #  puts file
      # end

      # Dir.glob((path + "/*.rb")).each do |file|
      #  puts file
      # end

      # File.expand_path((path + "/*.rb"), __FILE__).each do |file|
      #  puts file
      # end

      # Dir.glob(File.dirname(File.expand_path((path + "/*.rb"), __FILE__))).each do |file|
      #  require file
      # end
    end
  end
end
