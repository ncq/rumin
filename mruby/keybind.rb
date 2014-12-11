class Keybind
  def initialize(dsl_path, keymap)
    @keymap = keymap
    @binds = Hash.new

    dsl = File.open(dsl_path, 'r') do |f|
      f.read
    end

    instance_eval dsl
  end

  def press(ascii_code, buffer)
    @binds[ascii2keyname(ascii_code)].call(buffer)
  end

  def key?(ascii_code)
    @binds.key?(ascii2keyname(ascii_code))
  end

  private
    def bind(keyname, &block)
      @binds[keyname] = block
    end

    def ascii2keyname(ascii_code)
      @keymap.keyname ascii_code
    end
end
