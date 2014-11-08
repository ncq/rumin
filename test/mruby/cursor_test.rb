class CursorTest < MTest::Unit::TestCase
  require './mruby/cursor'

  def test_initialize
    cursor = Cursor.new
    assert_equal(0, cursor.row)
    assert_equal(0, cursor.col)
  end

  def test_set_position
    cursor = Cursor.new
    cursor.set_position(1, 2)
    assert_equal(1, cursor.row)
    assert_equal(2, cursor.col)
  end
end

MTest::Unit.new.run
