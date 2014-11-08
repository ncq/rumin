class Point
  attr_accessor :row, :col

  def initialize
    @row = 0
    @col = 0
  end

  def set_point(row, col)
    @row = row
    @col = col
  end

  def move_point(count = 1)
    @col = @col + count
  end

  def move_line(count = 1)
    @row = @row + count
  end
end
