class Content
  attr_reader :content

  def initialize(content = '')
    # should make inherited subclass
    raise AbstractClassException, 'Content class is abstract class. please make inherited subclass.'
   end

  def get_char(row, col)
    raise AbstractMethodException, "'get_char' is abstract method. please define on subclass."
  end

  def get_string(row, col, count)
    raise AbstractMethodException, "'get_string' is abstract method. please define on subclass."
  end

  def get_line(row)
    raise AbstractMethodException, "'get_line' is abstract method. please define on subclass."
  end

  def rows
    raise AbstractMethodException, "'rows' is abstract method. please define on subclass."
  end

  def insert_char(char, row, col)
    raise AbstractMethodException, "'insert_char' is abstract method. please define on subclass."
  end

  def insert_string(str, row, col)
    raise AbstractMethodException, "'insert_string' is abstract method. please define on subclass."
  end

  def replace_char(char, row, col)
    raise AbstractMethodException, "'replace_char' is abstract method. please define on subclass."
  end

  def replace_string(str, row, col)
    raise AbstractMethodException, "'replace_string' is abstract method. please define on subclass."
  end

  def add_line(row)
    raise AbstractMethodException, "'add_line' is abstract method. please define on subclass."
  end

  def change_line(row, col)
    raise AbstractMethodException, "'change_line' is abstract method. please define on subclass."
  end

  def delete_line(row)
    raise AbstractMethodException, "'delete_line' is abstract method. please define on subclass."
  end

  def to_string
    raise AbstractMethodException, "'to_string' is abstract method. please define on subclass."
  end

  def delete_char(count, row, col)
    raise AbstractMethodException, "'delete_char' is abstract method. please define on subclass."
  end

  def merge_line(count, row)
    raise AbstractMethodException, "'merge_line' is abstract method. please define on subclass."
  end
end
