class Echo
  attr_accessor :output
  def initialize
    Curses.echoline
    @output = 'echo'
    Curses.ewaddstr(@output)
    @input
  end

  def print_message(str)
    @output = str
    Curses.ewaddstr(@output)
  end

  def get_message
    @input = gets
    Curses.ewaddstr(@input)
    return str = @input
  end
end
