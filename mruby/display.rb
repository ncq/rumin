require './mruby/window'
require './mruby/echo_line'
require './mruby/screen'

class Display
  attr_reader :echo
  def initialize
    @window_list = []
    Curses.initscr
    Curses.cbreak
    Curses.noecho
    Curses.keypad(true)
    Curses.echoline
    @screen = Screen.new
    @echo = Echo.new
    true
  end

  def finish
    Curses.endwin
    true
  end

  def clear_screen
    Curses.clear
  end

  def create_window(buffer)
    window = Window.new(0, 0, @screen.rows, @screen.cols, buffer)
    @window_list << window
    window
  end

  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer      = window.buffer
      content     = buffer.content.content[window.start_row, window.rows]
      current_col = buffer.cursor.col
      current_row = buffer.cursor.row
      start_turn  = window.start_turn
      row         = 0
      content.each do |line|
        break if row == window.rows
        if line == ""
          row += 1
        else
          col = 0
          str = ""
          buffer.cursor.set_position(row, 0)
          line.each_char do |char|
            next if row == window.rows
            step = Utf8Util::full_width?(char) ? 2 : 1
            col += step
            str << char if col <= window.cols
            if col >= window.cols
              # word wrap
              if start_turn > 0
                start_turn -= 1
              else
                insert_string(str)
                row += 1
                buffer.cursor.set_position(row, 0)
              end
              if col == window.cols
                col = 0
                str = ""
              else
                col = 2
                str = char
              end
            end
          end
          if row < window.rows && str.length > 0
            insert_string(str)
            row += 1
          end
        end
      end
      buffer.cursor.set_position(current_row, current_col)
    end
    @echo.print
  end

  def insert_string(str)
    Curses.addstr(str)
  end
end
