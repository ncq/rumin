class Editor
  require './list'
  require './buffer'

  @buffer_chain
  @current_buffer

  def initialize
    @buffer_chain = LinkedList.new
    buffer = Buffer.new
    @buffer_chain.push(buffer)
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
  end

  def get_buffer_list
  end
end
