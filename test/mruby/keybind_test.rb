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

    assert keybind.key?(0)
  end

  def test_press
    keymap = Keymap.new('./test/fixture/keymap.yml')
    keybind = Keybind.new('./test/fixture/keyconfig.rb', keymap)

    assert keybind.press(0, MockBuffer.new)
  end
end

MTest::Unit.new.run
