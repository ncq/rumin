require './mruby/buffer'
require './mruby/cursor'

class Window
  attr_reader :cursor, :buffer
  def initialize(buffer)
    return false unless buffer.is_a?(Buffer)
    @cursor = Cursor.new
    @buffer = buffer
  end
end
