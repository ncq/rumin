class Keybind
	def initialize(dsl_path)
		@binds = Hash.new

		dsl = File.open(dsl_path, 'r') do |f|
			f.read
		end

		instance_eval dsl
	end

	def press(keyname, buffer)
		@binds[keyname].call(buffer)
	end

	def key?(keyname)
		@binds.key?(keyname)
	end

	private
		def bind(keyname, &block)
			@binds[keyname] = block
		end
end
