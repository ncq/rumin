require './mruby/window'

class Display
  def initialize
    @window_list = []
    Curses.initscr
    Curses.cbreak
    Curses.noecho
    true
  end

  def finish
    Curses::endwin
    true
  end

  def clear_screen
    Curses::clear
  end

  def create_window(buffer)
    window = Window.new(buffer)
    @window_list << window
    window
  end

  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer = window.buffer
      insert_string(buffer.get_content)
      buffer.cursor.set_position(buffer.cursor.row, buffer.cursor.col)
    end
  end

  def insert_string(str)
    Curses::addstr(str)
  end
end
