class Cursor
  attr_accessor :turn, :full_col, :full_row, :scrolled, :org_row
  attr_accessor :row, :col
  def initialize
    # cursor row(Y position) with scroll
    @row       = 0
    # cursor col with turn
    @col       = 0
    # turn count in one line
    @turn      = 0
    # cursor row without scroll
    @full_row  = 0
    # cursor col without turn
    @full_col  = 0
  end

  def set_position(row, col)
    @row = row
    @col = col
    Curses::move(row, col)
  end
end
