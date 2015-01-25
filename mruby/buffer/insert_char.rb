require './mruby/i_command'

class InsertChar < ICommand
  def initialize(buffer, content, point)
    super("Insert a character to buffer.")
    @buffer = buffer
    @content = content
    @point = point
  end

  def execute(char)
    @content.insert_char(char, @point.row, @point.col)
    @buffer.move_point(1)
    true
  end

  def unexecute
    begin
      @buffer.move_point(-1)
      @content.delete_char(1, @point.row, @point.col)
    rescue => e
      debug e.get_message
    end
    true
  end
end
