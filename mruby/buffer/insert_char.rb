require './mruby/i_command'
require './mruby/point'

class InsertChar < ICommand
  def initialize(buffer, content, point, cursor)
    super("Insert a character to buffer.")
    @buffer = buffer
    @content = content
    @point = Point.new
    @point.set_point(point.row, point.col)
    @cursor = cursor
  end

  def execute(char)
    @content.insert_char(char, @point.row, @point.col)
    @buffer.move_point(1)
    true
  end

  def unexecute
    @buffer.move_point(-1)
    @content.delete_char(1, @point.row, @point.col)
    @cursor.set_position(@point.row, @point.col)
    true
  end
end
