class Mark
  require './mruby/point'

  def initialize(name = mark, point)
    @name = name
    @location = Point.new
    @location.set_point(point.row, point.col)
    @is_fixed = false
  end

  def get_mark
    @location
  end

  def set_mark(point)
    @location.row = point.row
    @location.col = point.col
    true
  end

  def point_at_mark?(point)
    return false unless @location.row == point.row
    return false unless @location.col == point.col
    true
  end

  def point_before_mark?(point)
    return false if point_at_mark?(point)
    return false if @location.col > point.col
    true
  end

  def point_after_mark?(point)
    return false if point_at_mark?(point)
    return false if @location.col < point.col
    true
  end

  def swap_point_and_mark(point)
    swap = Point.new
    swap = point
    point = self
    self = swap
    true
  end
end
