# -*- coding: utf-8 -*-
class Command
  require './mruby/utf8_util'
	def initialize
		@keybind = Hash.new
		# File.open(File.expand_path('./mruby/config/keyconfig.rb'), 'r')
		dsl = File.open('./mruby/config/keyconfig.rb', 'r') do |f|
			f.read
		end

    load_command
		instance_eval(dsl)
	end

	def bind(key_name, process)
		@keybind[key_name] = process
	end

  def evaluate(inputs, buffer)
    input = Utf8Util::convert_utf_code(inputs)
    if @keybind.key?(input)
      eval @keybind[input]
    else
      # input character
      buffer.insert_char(input.chr)
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
