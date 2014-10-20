class Init
  attr_accessor :body
end

class Buffer
  def initialize
    @contents = []
  end

  def get_buffer
    @contents.join
  end

  def add_string(str)
    @contents << str
  end
end

class Command
  def evaluate(input, buffer)
    buffer.add_string(input.chr)
  end
end

