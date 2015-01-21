require './mruby/window'
require './mruby/echo_line'
require './mruby/screen'

class Display
  def initialize
    @window_list = []
    @echo_line = Echo.new
    Curses.initscr
    Curses.cbreak
    Curses.noecho
    Curses.keypad(true)
    Curses.echoline
    @screen = Screen.new
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

=begin
  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer     = window.buffer
      content    = buffer.content.content
      cursor_row = buffer.cursor.row
      cursor_col = buffer.cursor.col
      content    = content[window.start_row, window.rows]
      content.each_with_index do |line, row|
        buffer.cursor.set_position(row, 0)
        insert_string(line)
      end
      cursor_row = buffer.point.row - window.start_row
    Curses::ewmove(0, 0);
      point_row = buffer.point.row
      end_row   = window.start_row + window.rows
    Curses::ewaddstr("point:#{point_row} cursor:#{cursor_row} org_cursor:#{buffer.cursor.row} start:#{window.start_row} end:#{end_row} pagesize:#{window.rows}");
    Curses.refresh
      buffer.cursor.set_position(cursor_row, cursor_col)
    end
  end
=end

  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer      = window.buffer
      content     = buffer.content.content
      cursor_col  = buffer.cursor.col
      cursor_row  = buffer.cursor.row
      cursor_turn = buffer.cursor.turn
      start_turn  = window.start_turn
      content     = content[window.start_row, window.rows]
      row  = 0
      turn = 0
      content.each do |line|
        break if row == window.rows
        if line == ""
          row += 1
        else
          col = 0
          str = ""
          buffer.cursor.set_position(row, 0)
          line.each_char do |char|
            #break if row == window.rows
            next if row == window.rows
            step = Utf8Util::full_width?(char) ? 2 : 1
            col += step
            str << char if col <= window.cols
            # turn line
            if col >= window.cols
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
Curses::ewmove(0, 0);
point_row = buffer.point.row
end_row   = window.start_row + window.rows
# Curses::ewaddstr("point:#{point_row} cursor:#{cursor_row} org_cursor:#{buffer.cursor.org_row} cursor_full:#{buffer.cursor.full_row} turn:#{window.turn} scrolled:#{buffer.cursor.scrolled} start:#{window.start_row} start_turn:#{window.start_turn} end:#{end_row} pagesize:#{window.rows} move:#{window.move_row} before:#{window.before_start}");

Curses::ewaddstr("point_row:#{buffer.point.row} point_col:#{buffer.point.col} cursor_row:#{cursor_row} cursor_col:#{cursor_col} turn:#{buffer.cursor.turn} start_row:#{window.start_row} start_turn:#{window.start_turn} move_row:#{window.move_row} move_turn:#{window.turn}");
Curses.refresh
      buffer.cursor.set_position(cursor_row, cursor_col)
    end
  end


  def insert_string(str)
    Curses.addstr(str)
  end

  def get_echo
    @echo_line.line
  end

  def set_echo(str)
    @echo_line.line = str
  end
end

