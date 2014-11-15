class MarkTest < MTest::Unit::TestCase
  require './mruby/mark'

  def test_initialize
    point = Point.new
    mark = Mark.new('test', point)
    assert_equal(false, mark.is_fixed)
    assert_equal('test', mark.name)
    assert_equal(point.row, mark.location.row)
  end

  def test_set_mark
    point = Point.new
    mark = Mark.new('test', point)
    point.set_point(2, 3)
    mark.set_location(point)
    assert_equal(2, mark.location.row)
    assert_equal(3, mark.location.col)
  end

  def test_point_at_mark?
    point = Point.new
    mark = Mark.new('test', point)
    point.set_point(2, 3)
    mark.set_location(point)
    assert_equal(true, mark.point_at_mark?(point))
    point.set_point(2, 4)
    assert_equal(false, mark.point_at_mark?(point))
  end

  def test_point_before_mark?
    point = Point.new
    mark = Mark.new('test', point)
    point.set_point(2, 3)
    assert_equal(true, mark.point_before_mark?(point))
  end
end

MTest::Unit.new.run

