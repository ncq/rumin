class ScreenTest < MTest::Unit::TestCase
  require './mruby/screen'

  def test_initialize
    screen = Screen.new
    assert_not_equal(0, screen.rows)
    assert_not_equal(0, screen.cols)
  end

  def test_resize
    screen = Screen.new
    screen.resize
    assert_not_equal(0, screen.rows)
    assert_not_equal(0, screen.cols)
  end
end

MTest::Unit.new.run
