class WindowTest < MTest::Unit::TestCase
  require './mruby/window'
  require './mruby/buffer'

  def test_initialize
    buffer = Buffer.new('test')
    window = Window.new(buffer)
    assert_true(window.buffer.is_a?(Buffer))
    assert_equal('test', window.buffer.name)
    assert_true(window.cursor.is_a?(Cursor))
  end
end

MTest::Unit.new.run
