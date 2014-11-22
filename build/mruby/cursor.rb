class Cursor
  attr_accessor :row, :col
  def initialize
    @row = 0
    @col = 0
  end

  def set_position(row, col)
    @row = row
    @col = col
    Curses::move(row, col)
  end
end
