class BufferTest < MTest::Unit::TestCase
  require './mruby/buffer'
  require './mruby/window'

  def teardown
    Curses::endwin
  end

  def test_initialize
    buffer = create_buffer
    assert_equal(false, buffer.is_modified)
    assert_equal('test', buffer.name)
    assert_equal(0, buffer.num_chars)
    assert_equal(1, buffer.num_lines)
  end

  def test_get_cursor_row
    buffer = create_buffer
    buffer.cursor.set_position(2, 0)
    assert_equal(2, buffer.get_cursor_row)
  end

  def test_get_cursor_col
    buffer = create_buffer
    buffer.cursor.set_position(0, 2)
    assert_equal(2, buffer.get_cursor_col)
  end

  def test_get_char
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.point.set_point(0, 0)
    assert_equal('a', buffer.get_char)
    buffer.point.set_point(0, 2)
    assert_equal('c', buffer.get_char)
  end

  def test_get_string
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.point.set_point(0, 0)
    assert_equal('abc', buffer.get_string(3))
    assert_equal('ab', buffer.get_string(2))
    buffer.point.set_point(0, 1)
    assert_equal('bc', buffer.get_string(2))
  end

  def test_get_content
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('def')
    assert_equal("abc\ndef", buffer.get_content)
  end

  def test_insert_char_first
    buffer = create_buffer
    assert_equal(true, buffer.insert_char('a'))
    assert_equal('a', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(1, buffer.point.col)
    assert_equal(1, buffer.num_chars)
    assert_equal(true, buffer.is_modified)
  end

  def test_insert_char_second
    buffer = create_buffer
    buffer.insert_char('a')
    assert_equal(true, buffer.insert_char('b'))
    assert_equal('ab', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(2, buffer.point.col)
    assert_equal(2, buffer.num_chars)
  end

  def test_insert_string_first
    buffer = create_buffer
    assert_equal(true, buffer.insert_string('abc'))
    assert_equal('abc', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(3, buffer.num_chars)
    assert_equal(true, buffer.is_modified)
  end

  def test_insert_string_second
    buffer = create_buffer
    buffer.insert_string('abc')
    assert_equal(true, buffer.insert_string('def'))
    assert_equal('abcdef', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(6, buffer.point.col)
    assert_equal(6, buffer.num_chars)
  end

  def test_delete_char
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('def')
    buffer.delete(-2)
    assert_equal("abc\nd", buffer.get_content)
    assert_equal(1, buffer.point.row)
    assert_equal(1, buffer.point.col)
    assert_equal(4, buffer.num_chars)
  end

  def test_delete_merge_line
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('def')
    buffer.move_point(-3)
    buffer.delete(-1)
    assert_equal("abcdef", buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(6, buffer.num_chars)
  end

  def test_modified_true
    buffer = create_buffer
    buffer.insert_char('a')
    assert_equal(true, buffer.modified?)
  end

  def test_modified_false
    buffer = create_buffer
    assert_equal(false, buffer.modified?)
  end

  def test_move_point_default
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('def')
    buffer.move_point(-2)
    assert_equal(2, buffer.move_point())
    assert_equal(1, buffer.point.row)
    assert_equal(2, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(2, buffer.cursor.col)
  end

  def test_move_point_target
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('xyz')
    assert_equal(1, buffer.move_point(-2))
    assert_equal(1, buffer.point.row)
    assert_equal(1, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(1, buffer.cursor.col)
  end

  def test_move_point_not_move
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('xyz')
    buffer.move_point(-1)
    assert_equal(3, buffer.move_point(2))
    assert_equal(1, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_point_turn
    buffer = Buffer.new('test')
    window = Window.new(0, 0, 20, 40, buffer)
    buffer.insert_string('a' * 50)
    # move to prev turn
    assert_equal(30, buffer.move_point(-20))
    assert_equal(0, buffer.point.row)
    assert_equal(30, buffer.point.col)
    assert_equal(0, buffer.cursor.row)
    assert_equal(30, buffer.cursor.col)
    assert_equal(0, buffer.cursor.turn)
    # move to next turn
    assert_equal(45, buffer.move_point(15))
    assert_equal(0, buffer.point.row)
    assert_equal(45, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(5, buffer.cursor.col)
    assert_equal(1, buffer.cursor.turn)
  end

  def test_move_point_to_next_row
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('xyz')
    buffer.move_line(-1)
    assert_equal(0, buffer.move_point(1))
    assert_equal(1, buffer.point.row)
    assert_equal(0, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(0, buffer.cursor.col)
  end

  def test_move_point_to_prev_row
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('xyz')
    buffer.move_point(-3)
    assert_equal(3, buffer.move_point(-1))
    assert_equal(0, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(0, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_line_default
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('defg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.change_line
    buffer.insert_string('lmn')
    buffer.move_line(-2)
    assert_equal(2, buffer.move_line())
    assert_equal(2, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_line_target
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('defg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.change_line
    buffer.insert_string('lmn')
    assert_equal(1, buffer.move_line(-2))
    assert_equal(1, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_line_not_move
    buffer = create_buffer
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('defg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.change_line
    buffer.insert_string('lmn')
    buffer.move_line(-1)
    assert_equal(3, buffer.move_line(2))
    assert_equal(3, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(3, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_line_with_turn_to_next
    buffer = Buffer.new('test')
    window = Window.new(0, 0, 20, 40, buffer)
    buffer.insert_string('a' * 52)
    buffer.change_line
    buffer.insert_string('b' * 50)
    buffer.change_line
    buffer.insert_string('c' * 52)
    buffer.move_line(-5)
    # move to next turn
    assert_equal(0, buffer.move_line(1))
    assert_equal(0, buffer.point.row)
    assert_equal(52, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(12, buffer.cursor.col)
    assert_equal(1, buffer.cursor.turn)
    # move to next row
    assert_equal(1, buffer.move_line(1))
    assert_equal(1, buffer.point.row)
    assert_equal(12, buffer.point.col)
    assert_equal(2, buffer.cursor.row)
    assert_equal(12, buffer.cursor.col)
    assert_equal(0, buffer.cursor.turn)
    # move to next row multi
    assert_equal(2, buffer.move_line(2))
    assert_equal(2, buffer.point.row)
    assert_equal(12, buffer.point.col)
    assert_equal(4, buffer.cursor.row)
    assert_equal(12, buffer.cursor.col)
    assert_equal(0, buffer.cursor.turn)
  end

  def test_move_line_with_turn_to_prev
    buffer = Buffer.new('test')
    window = Window.new(0, 0, 20, 40, buffer)
    buffer.insert_string('a' * 52)
    buffer.change_line
    buffer.insert_string('b' * 50)
    buffer.change_line
    buffer.insert_string('c' * 52)
    # move to prev turn
    assert_equal(2, buffer.move_line(-1))
    assert_equal(2, buffer.point.row)
    assert_equal(12, buffer.point.col)
    assert_equal(4, buffer.cursor.row)
    assert_equal(12, buffer.cursor.col)
    assert_equal(0, buffer.cursor.turn)
    # move to prev row
    assert_equal(1, buffer.move_line(-1))
    assert_equal(1, buffer.point.row)
    assert_equal(50, buffer.point.col)
    assert_equal(3, buffer.cursor.row)
    assert_equal(10, buffer.cursor.col)
    assert_equal(1, buffer.cursor.turn)
    # move to prev row multi
    assert_equal(0, buffer.move_line(-2))
    assert_equal(0, buffer.point.row)
    assert_equal(52, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(12, buffer.cursor.col)
    assert_equal(1, buffer.cursor.turn)
  end

  def test_change_line
    buffer = create_buffer
    buffer.insert_string('abcdefg')
    buffer.move_point(-4)
    assert_equal(2, buffer.change_line)
    assert_equal(2, buffer.num_lines)
    assert_equal(7, buffer.num_chars)
    assert_equal(1, buffer.point.row)
    assert_equal(0, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(0, buffer.cursor.col)
  end

  def test_delete_line_first
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.insert_string('efg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.move_line(-2)
    buffer.delete_line
    assert_equal("efg\nhijk", buffer.get_content)
    assert_equal(2, buffer.num_lines)
    assert_equal(7, buffer.num_chars)
    assert_equal(0, buffer.point.row)
    assert_equal(4, buffer.point.col)
  end

  def test_delete_line_middle
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.insert_string('efg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.move_line(-1)
    buffer.delete_line
    assert_equal("abcd\nhijk", buffer.get_content)
    assert_equal(2, buffer.num_lines)
    assert_equal(8, buffer.num_chars)
    assert_equal(1, buffer.point.row)
    assert_equal(3, buffer.point.col)
  end

  def test_delete_line_last
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.insert_string('efg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.delete_line
    assert_equal("abcd\nefg", buffer.get_content)
    assert_equal(2, buffer.num_lines)
    assert_equal(7, buffer.num_chars)
    assert_equal(1, buffer.point.row)
    assert_equal(3, buffer.point.col)
  end

=begin
  def test_copy_character
    buffer = Buffer.new('test')
    buffer.insert_string('abcd')
    buffer.move_point(-3)
    assert_equal('b', buffer.copy_character) 
    buffer.move_point(2)
    assert_equal('d', buffer.copy_character) 
  end

  def test_paste_character
    buffer = Buffer.new('test')
    buffer.insert_string('abcd')
    buffer.move_point(-3)
    buffer.copy_character
    buffer.move_point(2)
    buffer.paste_character
    buffer.move_point(-4)
    assert_equal('abcbd', buffer.get_string(5)) 
  end
=end

  def test_copy_string
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    assert_equal("bcd", buffer.clipboard.content[0])
    buffer.copy_mark.set_location(0, 4)
    buffer.point.set_point(0, 2)
    buffer.copy
    assert_equal("cd", buffer.clipboard.content[0])
  end

  def test_copy_string_region
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.insert_string('efgh')
    buffer.change_line
    buffer.insert_string('ijkl')
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    assert_equal("bcd\nefgh\nijkl", buffer.clipboard.content.join)
    buffer.copy_mark.set_location(1, 1)
    buffer.copy
    assert_equal("fgh\nijkl", buffer.clipboard.content.join)
    buffer.point.set_point(1, 2)
    buffer.copy_mark.set_location(2, 2)
    buffer.copy
    assert_equal("gh\nij", buffer.clipboard.content.join)
  end

  def test_copy_string_region2
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    assert_equal("bcd\n", buffer.clipboard.content.join)
  end

  def test_paste_string2
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    buffer.paste_string
    assert_equal("abcd\nbcd\n", buffer.get_content)
  end

  def test_paste_string
    buffer = create_buffer
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.insert_string('efgh')
    buffer.change_line
    buffer.insert_string('ijkl')
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    buffer.paste_string
    assert_equal("abcd\nefgh\nijklbcd\nefgh\nijkl", buffer.get_content)
  end

  def test_store_select
    buffer = create_buffer
    buffer.insert_string('1 + 1')
    buffer.store_select(buffer.evaluate_mark, buffer.evaluate)
    assert_equal("1 + 1", buffer.evaluate.content[0])

    buffer.change_line
    buffer.insert_string('puts "a"')
    buffer.store_select(buffer.evaluate_mark, buffer.evaluate)
    assert_equal('1 + 1puts "a"', buffer.evaluate.content.join)
  end

  def test_eval_content
    buffer = create_buffer
    buffer.insert_string('1 + 1')
    assert_equal(2, buffer.eval_content)
  end

  def test_insert_evaluated_content_comment
    buffer = create_buffer
    buffer.insert_string('1 + 1')
    buffer.insert_string(' ')
    buffer.insert_evaluated_content_comment
    assert_equal('1 + 1 # => 2', buffer.content.to_string)

    buffer = create_buffer
    buffer.insert_string('a + 1')
    buffer.insert_string(' ')
    buffer.insert_evaluated_content_comment
    assert_equal(%[a + 1 # => error: undefined method 'a' for main], buffer.get_content)
  end

  def test_insert_evaluated_line_comment
    buffer = create_buffer
    buffer.insert_string("hoge")
    buffer.change_line
    buffer.insert_string("1 + 1")
    buffer.insert_evaluated_line_comment
    assert_equal("hoge\n1 + 1 # => 2", buffer.get_content)

    buffer = create_buffer
    buffer.insert_string("hoge")
    buffer.change_line
    buffer.insert_string("1 + a")
    buffer.insert_evaluated_line_comment
    assert_equal(%[hoge\n1 + a # => error: undefined method 'a' for main], buffer.get_content)
  end

  def test_read_file
    test_file_name = './test/fixture/test.txt'#'./test/fixture/buffer_read.txt'
    `touch #{test_file_name}`
    `echo "test\ntest" > #{test_file_name}`
    buffer = create_buffer
    buffer.set_file_name(test_file_name)
    assert_equal(true, buffer.read_file)
    assert_equal("test\ntest", buffer.get_content)
  end

  def test_write_file
    test_file_name = './test/fixture/buffer_write.txt'
    buffer = create_buffer
    buffer.set_file_name(test_file_name)
    buffer.insert_string('test\n')
    assert_equal(true, buffer.write_file)
    expectation = Buffer.new('expectation')
    expectation.set_file_name(test_file_name)
    expectation.read_file
    assert_equal('test\n', expectation.get_content)
  end

  def test_is_file_changed?
    test_file_name = './test/fixture/buffer_changed.txt'
    `touch #{test_file_name}`
    buffer = create_buffer
    buffer.set_file_name(test_file_name)
    assert_equal(false, buffer.is_file_changed?)
  end

  def test_set_window
    buffer = Buffer.new('test')
    window = Window.new(0, 10, 40, 80, buffer)
    buffer.set_window(buffer)
    assert_equal(window, buffer.window)
    assert_false(buffer.set_window(nil))
  end

  def test_window_resize
    pass('This method is unable to unit test because this method use Curses.')
  end

  def test_print_message
    buffer = Buffer.new('test')
    buffer.display.echo.print_message("hoge")
    assert_equal("hoge", buffer.display.echo.output)
  end

  def create_buffer(name = 'test')
    buffer = Buffer.new(name)
    window = Window.new(0, 0, 40, 80, buffer)
    buffer
  end
end

MTest::Unit.new.run
