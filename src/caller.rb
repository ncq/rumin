class Caller
  attr_accessor :str1, :str2

  def initialize(arg1, arg2)
    @str1 = "baz"
    @str2 = "bar"
  end

  def print
    puts @str1
    puts @str2
  end
end


