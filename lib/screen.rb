require "curses"

class Screen
  attr_reader :rows, :cols
  def initialize
    @rows = Curses.lines
    @cols = Curses.cols
  end

  def resize
    @rows = Curses.lines
    @cols = Curses.cols
  end
end
