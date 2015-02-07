require './mruby/buffer'

class Window
  # echo-area size
  ECHO_AREA_ROWS = 1
  attr_reader :buffer, :top, :left, :rows, :cols, :start_row, :start_turn
  def initialize(top, left, rows, cols, buffer)
    return false unless buffer.is_a?(Buffer)
    @buffer = buffer
    @buffer.set_window(self)
    @top        = top
    @left       = left
    @rows       = rows - ECHO_AREA_ROWS
    @cols       = cols
    @start_row  = top
    @start_turn = 0
  end

  def scroll_line(row, turn, count)
    if count > 0
      # scroll to bottom
      if row > @start_row || (row == @start_row && turn > @start_turn)
        @start_row  = row
        @start_turn = turn
        return true
      end
    else
      # scroll to top
      if row < @start_row || (row == @start_row && turn < @start_turn)
        @start_row  = row
        @start_turn = turn
        return true
      end
    end
    false
  end

  def resize
    @rows = Curses::screen_rows - ECHO_AREA_ROWS
    @cols = Curses::screen_cols
  end
end
