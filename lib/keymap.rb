class Keymap
  def initialize(yaml_path)
    yaml = File.open(yaml_path, 'r') do |f|
      f.read
    end

    @map = YAML.load yaml
  end

  # asciiコードを渡すと、対応するキーネームを返す
  def keyname(ascii_code)
    @map[ascii_code]
  end
end
