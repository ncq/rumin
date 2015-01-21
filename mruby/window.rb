require './mruby/buffer'
require './mruby/cursor'

class Window
  #attr_reader :cursor, :buffer, :top, :left, :rows, :cols, :start_row, :start_turn
  attr_reader :cursor, :buffer, :top, :left, :rows, :cols, :start_row, :start_turn, :before_start, :move_row, :turn
  def initialize(top, left, rows, cols, buffer)
    return false unless buffer.is_a?(Buffer)
    @cursor = Cursor.new
    @buffer = buffer
    @buffer.set_window(self)
    @top        = top
    @left       = left
    # minus echoline size
    @rows       = rows - 1
    @cols       = cols
    @start_row  = top
    @start_turn = 0
  end

=begin
  def scroll_line(row)
@move_row = row
@before_start = @start_row
    end_row = @start_row + @rows
    if row < @start_row
      @start_row = row
    elsif row > end_row
      @start_row = @start_row + (row - end_row)
    end
    @start_row
  end
=end

  def scroll_line(row, turn, count)
@move_row = row
@before_start = @start_row
@turn = turn
    if count > 0
      if row > @start_row || (row == @start_row && turn > @start_turn)
        @start_row  = row
        @start_turn = turn
        return true
      end
    else
      if row < @start_row || (row == @start_row && turn < @start_turn)
        @start_row  = row
        @start_turn = turn
        return true
      end
    end
    false
  end

  def resize
    @rows = Curses::screen_rows - 1
    @cols = Curses::screen_cols
    #@rows = 10
    #@cols = 20
  end
end
