class MockBuffer
  def ok
    true
  end
end

class KeybindTest < MTest::Unit::TestCase
  require './mruby/keybind'
  require './mruby/keymap'

  def test_initialize
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)

    assert_instance_of(Keybind, keybind)
  end

  def test_key?
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)

    assert keybind.key?(24)
  end

	def test_valid_nested_key?
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)
	
		keybind.press(24, MockBuffer.new)
		assert keybind.key?(1)
	end

	def test_invalid_nested_key?
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)
	
		keybind.press(24, MockBuffer.new)
		assert_equal false, keybind.key?(2)
	end

  def test_press
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)

    assert keybind.press(1, MockBuffer.new)
  end
end

MTest::Unit.new.run
