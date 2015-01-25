require './mruby/i_command'

class ChangeLine < ICommand
  def initialize(buffer, content, point, cursor)
    super('Change line.')
    @buffer = buffer
    @content = content
    @point = point
    @cursor = cursor
  end

  def execute
    debug 'ChangeLine#execute'
    begin
    @content.change_line(@point.row, @point.col)
    @point.set_point((@point.row + 1), 0)
    @cursor.set_position(@point.row, @point.col)
    rescue => e
      debug e.message
    end
  end

  def unexecute
    debug 'ChangeLine#unexecute'
    begin
    old_line   = @content.get_line(@point.row - 1)
    old_length = old_line.length
    @content.delete_line(@point.row)
    if @content.rows == 0
      @point.set_point(0, 0)
      @cursor.set_position(0, 0)
    else
      if @point.row >= @content.rows
        @buffer.move_line(-1)
      else
        @buffer.move_line(0)
      end
    end
    rescue => e
      debug e.message
    end
    true
  end
end
