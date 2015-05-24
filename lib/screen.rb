require "curses"

class Screen
  attr_reader :rows, :cols
  def initialize
    @rows = Curses::screen_rows
    @cols = Curses::screen_cols
  end

  def resize
    @rows = Curses::screen_rows
    @cols = Curses::screen_cols
  end
end
