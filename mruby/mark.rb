class Mark
  require './mruby/point'

  attr_accessor :name, :is_fixed, :location
  #attr_reader :location
  def initialize(name = mark, point)
    @name = name
    @location = Point.new
    @location.set_point(point.row, point.col)
    @is_fixed = false
  end

  def set_location(point)
    @location.set_point(point.row, point.col)
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

=begin
  def swap_point_and_mark(point)
    swap = Point.new
    swap = point
    point = self
    self = swap
    true
  end
=end

end

