class Editor
  require './mruby/list'
  require './mruby/buffer'

  attr_reader :current_buffer
  def initialize
    @buffer_chain = LinkedList.new
    buffer = Buffer.new('default')
    @buffer_chain.push(buffer)
    @current_buffer = buffer
    @serial = 0
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
      @serial += 1
      name = "default_#{@serial}"
    end
    new_buffer = Buffer.new(name)
    @buffer_chain.push(new_buffer)
    new_buffer
  end

  def clear_buffer
  end

  def delete_buffer
  end

  def set_current_buffer(name)
    @current_buffer
  end

  def get_buffer_list
    buffer_list = Array.new
    @buffer_chain.each { |buffer|
      buffer_list.push(buffer)
    }
    buffer_list
  end
end
