class Display
  require './mruby/window'
  require './mruby/echo_line'
  attr_accessor :echo
  def initialize
    @window_list = []
    Curses.initscr
    Curses.cbreak
    Curses.noecho
    Curses.keypad(true)
    Curses.echoline
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
    window = Window.new(buffer)
    @window_list << window
    window
  end

  def redisplay
    clear_screen
    @window_list.each do |window|
      buffer     = window.buffer
      content    = buffer.content.content
      cursor_row = buffer.cursor.row
      cursor_col = buffer.cursor.col
      color_map  = buffer.content.color_map.color_map
      content.each_with_index do |line, row|
        buffer.cursor.set_position(row, 0)
        colors = color_map[row]
        if colors.size > 0
          col    = 0
          length = line.length
          while (col < length) do
            color = colors[0]
            if color > 0
              Curses.coloron(color)
            end
            index = colors.find_index{|code| code != color }
            if index.nil?
              insert_string(line[col, (line.length - col)])
              col = line.length
            else
              insert_string(line[col, index])
              colors = colors[index, (colors.size - index)]
              col = col + index
            end
            if color > 0
              Curses.coloroff(color)
            end
          end
        else
          insert_string(line)
        end
      end
      buffer.cursor.set_position(cursor_row, cursor_col)
    end
    @echo.print
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
