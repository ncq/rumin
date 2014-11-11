class Editor
  require './mruby/list'
  require './mruby/buffer'

  @buffer_chain
  @current_buffer

  def initialize
    @buffer_chain = LinkedList.new
    buffer = Buffer.new('default')
    @buffer_chain.push(buffer)
    @current_buffer = buffer
  end

  def finish
  end

  def save
  end

  def load
  end

  def create_buffer
  end

  def clear_buffer
  end

  def delete_buffer
  end

  def set_current_buffer
    @current_buffer
  end

  def get_buffer_list
    
  end
end
