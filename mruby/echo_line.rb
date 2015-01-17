class Echo
  attr_accessor :output
  def initialize
    @output = 'echo'
    @input
    Curses.ewmove(0, 0)
  end

  def print_message(str)
    @output = str
    Curses.ewmove(0, 0)
    Curses.ewaddstr(@output)
  end

  def print
    Curses.ewmove(0, 0)
    Curses.ewaddstr(@output)
  end

  def get_parameter(message)
    Curses.nocbreak
    print_message(message)
    @input = Curses.ewgetstr
    return @input
  end
end
