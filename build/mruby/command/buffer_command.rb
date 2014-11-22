# -*- coding: utf-8 -*-
class BufferCommand
  class << self
    def up(buffer)
      buffer.move_line(-1)
    end
    def down(buffer)
      buffer.move_line(1)
    end
    def left(buffer)
      buffer.move_point(-1)
    end
    def right(buffer)
      buffer.move_point(1)
    end

    def change_line(buffer)
      buffer.change_line
    end
    def buffer_delete(buffer)
      buffer.delete(-1)
    end
    def buffer_del2(buffer)
      buffer.delete(-2)
    end

    def set_mark(buffer)
      buffer.copy_mark
    end

  end
end
