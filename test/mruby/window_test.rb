class WindowTest < MTest::Unit::TestCase
  require './mruby/window'
  require './mruby/buffer'

  def teardown
    Curses::endwin
  end

  def test_initialize
    buffer = Buffer.new('test')
    window = Window.new(0, 10, 40, 80, buffer)
    assert_true(window.buffer.is_a?(Buffer))
    assert_equal('test', window.buffer.name)
    assert_equal(0, window.top)
    assert_equal(10, window.left)
    assert_equal(39, window.rows)
    assert_equal(80, window.cols)
  end

  def test_scroll_line_bottom
    buffer = Buffer.new('test')
    window = Window.new(0, 10, 40, 80, buffer)
    # change row
    assert_true(window.scroll_line(2, 0, 1))
    assert_equal(2, window.start_row)
    assert_equal(0, window.start_turn)
    # change turn
    assert_true(window.scroll_line(2, 1, 1))
    assert_equal(2, window.start_row)
    assert_equal(1, window.start_turn)
    # not change
    assert_false(window.scroll_line(1, 1, 1))
    assert_false(window.scroll_line(1, 2, 1))
  end

  def test_scroll_line_top
    buffer = Buffer.new('test')
    window = Window.new(0, 10, 40, 80, buffer)
    # prepare
    assert_true(window.scroll_line(10, 0, 10))
    assert_equal(10, window.start_row)
    assert_equal(0, window.start_turn)
    # change row
    assert_true(window.scroll_line(9, 1, -1))
    assert_equal(9, window.start_row)
    assert_equal(1, window.start_turn)
    # change turn
    assert_true(window.scroll_line(9, 0, -1))
    assert_equal(9, window.start_row)
    assert_equal(0, window.start_turn)
    # not change
    assert_false(window.scroll_line(10, 0, -1))
    assert_false(window.scroll_line(10, 1, -1))
  end

  def test_resize
    buffer = Buffer.new('test')
    window = Window.new(0, 0, 0, 0, buffer)
    window.resize
    assert_not_equal(0, window.rows)
    assert_not_equal(0, window.cols)
  end
end

MTest::Unit.new.run
