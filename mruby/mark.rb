class Mark
  require './mruby/point'

  attr_accessor :name, :location
  #attr_reader :location
  def initialize(name = "mark", point)
    @name = name
    @location = Point.new
    @location.set_point(point.row, point.col)
  end

  def set_location(row, col)
    @location.set_point(row, col)
    true
  end

  def point_at_mark?(point)
    return false unless @location.row == point.row && @location.col == point.col
    true
  end

  def point_before_mark?(point)
    return false if point_at_mark?(point)
    return false if @location.col < point.col
    true
  end

  def point_after_mark?(point)
    return false if point_at_mark?(point)
    return false if @location.col > point.col
    true
  end

  def swap_point_and_mark(point)
    swap = Point.new
    swap.set_point(point.row, point.col)
    point.set_point(self.location.row, self.location.col)
    self.location.set_point(swap.row, swap.col)
    true
  end

end

