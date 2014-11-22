class Keybind
	extend Forwadable
	def_delegator :@binds, :key?, :bind?

	def initialize(dsl_path)
		@binds = Hash.new

		dsl = File.open(dsl_path, 'r') do |f|
			f.read
		end

		instance_eval dsl
	end

	def press(keyname, buffer)
	end

	private
		def bind(keyname, &block)
			@binds[keyname] = block
		end
end
