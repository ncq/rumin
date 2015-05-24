class Keybind
	require 'bind'

  def initialize(dsl_path, keymap)
    @keymap = keymap
    # @binds = Hash.new
		@binds = Bind.new
		@current = nil

    dsl = File.open(dsl_path, 'r') do |f|
      f.read
    end

    instance_eval dsl
  end

  def press(ascii_code, buffer)
    # @binds[ascii2keyname(ascii_code)].call(buffer)
		keyname = ascii2keyname(ascii_code)
		@current ||= @binds
		@current = @current[keyname]

		if @current.has_proc? then
			@current.call(buffer)
			@current = nil
			return true
		end
  end

  def key?(ascii_code)
    # @binds.key?(ascii2keyname(ascii_code))
		@current ||= @binds
		debug ascii_code
		debug @current.key?(ascii2keyname(ascii_code))
		@current.key?(ascii2keyname(ascii_code))
  end

  private
    def bind(keynames, &block)
      # @binds[keyname] = block
			tmp = @binds
			keynames.each do |keyname|
				if tmp.key?(keyname) then
					tmp = tmp[keyname]
				else
					tmp = tmp[keyname] = Bind.new
				end
			end

			tmp.block = block
    end

    def ascii2keyname(ascii_code)
      @keymap.keyname ascii_code
    end
end
