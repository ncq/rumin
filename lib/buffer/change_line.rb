require 'i_command'
require 'point'

class ChangeLine < ICommand
  def initialize(buffer, content, point, cursor)
    super('Change line.')
    @buffer = buffer
    @content = content
    @current_point = point
    @old_point = Point.new
    @old_point.set_point(point.row, point.col)
    @cursor = cursor
  end

  def execute
    @content.change_line(@current_point.row, @current_point.col)
    @current_point.set_point((@current_point.row + 1), 0)
    @cursor.set_position(@current_point.row, @current_point.col)
  end

  def unexecute
    old_line   = @content.get_line(@old_point.row)
    old_length = old_line.length
    @content.delete_line(@old_point.row + 1)
    if @content.rows == 0
      @current_point.set_point(0, 0)
      @cursor.set_position(0, 0)
    else
      if @current_point.row >= @content.rows
        @buffer.move_line(-1)
        debug 'move_line(-1)'
        col_c = @content.convert_point_to_cursor(@current_point.row, @current_point.col)
        @cursor.set_position(@old_point.row, @old_point.col)
      else
        @buffer.move_line(0)
      end
    end
    true
  end
end
