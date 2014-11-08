class PointTest < MTest::Unit::TestCase
  require './mruby/point'

  def test_initialize
    point = Point.new
    assert_equal(0, point.row)
    assert_equal(0, point.col)
  end

  def test_set_point
    point = Point.new
    point.set_point(1, 2)
    assert_equal(1, point.row)
    assert_equal(2, point.col)
  end

  def test_move_point_default
    point = Point.new
    point.move_point()
    assert_equal(1, point.col)
  end

  def test_move_point_target
    point = Point.new
    point.move_point(4)
    assert_equal(4, point.col)
  end

  def test_move_point_minus
    point = Point.new
    point.move_point(4)
    point.move_point(-3)
    assert_equal(1, point.col)
  end

  def test_move_line_default
    point = Point.new
    point.move_line()
    assert_equal(1, point.row)
  end

  def test_move_line_target
    point = Point.new
    point.move_line(4)
    assert_equal(4, point.row)
  end

  def test_move_line_minus
    point = Point.new
    point.move_line(4)
    point.move_line(-3)
    assert_equal(1, point.row)
  end
end

MTest::Unit.new.run
