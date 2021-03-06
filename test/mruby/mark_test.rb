class MarkTest < MTest::Unit::TestCase
  require './mruby/mark'

  def test_initialize
    point = Point.new
    mark = Mark.new('test', point)
    assert_equal('test', mark.name)
    assert_equal(point.row, mark.location.row)
  end

  def test_set_location
    point = Point.new
    mark = Mark.new('test', point)
    mark.set_location(2, 3)
    assert_equal(2, mark.location.row)
    assert_equal(3, mark.location.col)
  end

  def test_point_at_mark?
    point = Point.new
    mark = Mark.new('test', point)
    point.set_point(2, 3)
    mark.set_location(2, 3)
    assert_equal(true, mark.point_at_mark?(point))
    point.set_point(2, 4)
    assert_equal(false, mark.point_at_mark?(point))
  end

  def test_point_before_mark?
    point = Point.new
    mark = Mark.new('test', point)
    assert_equal(false, mark.point_before_mark?(point))
    point.set_point(2, 3)
    assert_equal(false, mark.point_before_mark?(point))
    mark.set_location(4, 5)
    assert_equal(true, mark.point_before_mark?(point))
    mark.set_location(4, 2)
    assert_equal(true, mark.point_before_mark?(point))
    mark.set_location(1, 5)
    assert_equal(false, mark.point_before_mark?(point))
  end

=begin
  def test_point_after_mark?
    point = Point.new
    mark = Mark.new('test', point)
    assert_equal(false, mark.point_after_mark?(point))
    point.set_point(2, 3)
    assert_equal(true, mark.point_after_mark?(point))
    mark.set_location(1, 2)
    assert_equal(true, mark.point_after_mark?(point))
    mark.set_location(4, 2)
    assert_equal(true, mark.point_after_mark?(point))
  end
=end

  def test_exchange_point_and_mark
    point = Point.new
    mark = Mark.new('test', point)
    point.set_point(2, 3)
    mark.exchange_point_and_mark(point)
    assert_equal(2, mark.location.row)
    assert_equal(3, mark.location.col)
    assert_equal(0, point.row)
    assert_equal(0, point.col)
  end

  def test_same_row?
    point = Point.new
    mark = Mark.new('test', point)
    assert_equal(true, mark.same_row?(point))
    point.set_point(2, 3)
    assert_equal(false, mark.same_row?(point))
  end
end

MTest::Unit.new.run

