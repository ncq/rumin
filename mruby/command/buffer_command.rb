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

    def eval_current_buffer(buffer)
      eval(buffer.content.to_string)
    end

    def set_copy_mark(buffer)
      buffer.set_copy_mark
    end

    def copy(buffer)
      buffer.copy
    end

    def paste_string(buffer)
      buffer.paste_string
    end
  end
end
