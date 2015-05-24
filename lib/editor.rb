class Editor
  require 'list'
  require 'buffer'
  require 'display'

  attr_reader :current_buffer, :display

  def initialize
    @buffer_chain = LinkedList.new
    buffer = Buffer.new('default')
    @buffer_chain.push(buffer)
    @current_buffer = buffer
    @serial = 0
    @display = Display.new
  end

  def finish
    result = true
    @buffer_chain.each do |buffer|
      if buffer.modified? then
        result = false
        break
      end
    end
    result
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
    @current_buffer = new_buffer
    new_buffer
  end

  def clear_buffer
    @current_buffer.content = ''
  end

  def delete_buffer(name)
    target = nil
    @buffer_chain.each_with_index do |buffer, i|
      if buffer.name == name then
        target = i
      end
    end
    @buffer_chain.delete_at(target)
    true
  end

  def set_current_buffer(name)
    @buffer_chain.each do |buffer|
      if buffer.name == name then
        @current_buffer = buffer
      end
    end
    @current_buffer
  end

  def get_buffer_list
    buffer_list = Array.new
    @buffer_chain.each do |buffer|
      buffer_list.push(buffer.name)
    end
    buffer_list
  end
end
