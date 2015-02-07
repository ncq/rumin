require './mruby/window'
require './mruby/echo_line'
require './mruby/screen'

class Display
  attr_reader :screen
  attr_accessor :echo
  def initialize
    @window_list = []
    Curses.initscr
    Curses.cbreak
    Curses.noecho
    Curses.keypad(true)
    @screen = Screen.new
    Curses.echoline((@screen.rows - 1), 3)
    @echo = Echo.new
    Curses.start_color()
    Curses.init_pair(1, Curses::COLOR_BLUE, Curses::COLOR_WHITE)
    Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
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
      color_map   = buffer.content.color_map.color_map
      row_p       = window.start_row
      row_c       = 0
      keep_color  = 0
      content.each do |line|
        break if row_c == window.rows
        if line == ""
          row_p += 1
          row_c += 1
        else
          col_c  = 0
          col_p  = 0
          str    = ""
          colors = color_map[row_p]
          buffer.cursor.set_position(row_c, 0)
          line.each_char do |char|
            next if row_c == window.rows
            color = colors[col_p]
            if color != keep_color
              # change color
              insert_string(str)
              str = ""
              Curses.coloroff(keep_color) if keep_color > 0
              Curses.coloron(color) if color > 0
              keep_color = color
            end
            step = Utf8Util::full_width?(char) ? 2 : 1
            col_c += step
            str << char if col_c <= window.cols
            if col_c >= window.cols
              # word wrap
              if start_turn > 0
                start_turn -= 1
              else
                insert_string(str)
                row_c += 1
                buffer.cursor.set_position(row_c, 0)
              end
              if col_c == window.cols
                col_c = 0
                str = ""
              else
                col_c = 2
                str = char
              end
            end
            col_p += 1
          end
          if row_c < window.rows && str.length > 0
            insert_string(str)
            row_c += 1
          end
          row_p += 1
        end
      end
      Curses.coloroff(keep_color) if keep_color > 0
      buffer.cursor.set_position(current_row, current_col)
    end
    @echo.print
  end

  def insert_string(str)
    Curses.addstr(str)
  end
end
