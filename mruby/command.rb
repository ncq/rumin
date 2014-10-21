class Command
  def evaluate(input, buffer)
    if input == 10
      # enter key
      buffer.change_line
    elsif input == 127
      # delete key
      buffer.delete(-1);
    else
      buffer.insert_char(input.chr)
     end
  end
end
