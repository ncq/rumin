class KeymapTest < MTest::Unit::TestCase
  require './mruby/keymap'

  def test_initialize
    keymap = Keymap.new('./test/fixture/keymap.yml')
    assert_instance_of(Keymap, keymap)
  end

  def test_ascii_to_keyname
    keymap = Keymap.new('./test/fixture/keymap.yml')
    assert_equal('ctrl-sp', keymap.keyname(0))
  end
end

MTest::Unit.new.run
