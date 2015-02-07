class Point
  attr_accessor :row, :col, :hold_col

  def initialize
    # point row(Y position)
    @row      = 0
    # point col(X position)
    @col      = 0
    # hold col when a row has changed
    @hold_col = 0
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
