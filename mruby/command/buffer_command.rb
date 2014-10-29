# -*- coding: utf-8 -*-
class BufferCommand
  class << self
    # TODO: とりあえずbuffer引数にするけど、editorとdisplayをインスタンス変数にセットする
    def change_line(buffer)
      buffer.change_line
    end

  end
end
