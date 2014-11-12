class Editor
  require './mruby/list'
  require './mruby/buffer'

  @buffer_chain
  @current_buffer

  def initialize
    @buffer_chain = LinkedList.new
    buffer = Buffer.new('default')
    @buffer_chain.push(buffer)
  end

  def finish
  end

  def save
    @current_buffer.write_file
  end

  def load
    @current_buffer.read_file
  end

  def create_buffer(name = nil)
    if name == nil then
      name = 'default'
    end
    new_buffer = Buffer.new(name)
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
