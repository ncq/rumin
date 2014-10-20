class Init
  attr_accessor :body
end

class Buffer
  def initialize
    @contents = ["dog", "cat", "fish"]
  end

  def get_buffer
    @contents.join("\n")
  end

  def add_string(str)
    @contents << str
  end
end

class Command
  def initialize
    
  end

  def evaluate(input, buffer)
    buffer.add_string(input)
  end
end


bu = Buffer.new
p bu.get_buffer
co = Command.new
p co.evaluate(27, bu)
p bu.get_buffer

