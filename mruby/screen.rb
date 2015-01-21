class Screen
  attr_reader :rows, :cols
  def initialize
    @rows = Curses::screen_rows
    @cols = Curses::screen_cols
    @rows = 11
    @cols = 10
  end

  def resize
    @rows = Curses::screen_rows
    @cols = Curses::screen_cols
    @rows = 11
    @cols = 10
  end
end
