class BufferTest < MTest::Unit::TestCase
  require './mruby/buffer'

  def test_initialize
    buffer = Buffer.new('test')
    assert_equal(false, buffer.is_modified)
    assert_equal('test', buffer.name)
    assert_equal(0, buffer.num_chars)
    assert_equal(1, buffer.num_lines)
  end

  def test_get_cursor_row
    buffer = Buffer.new('test')
    buffer.cursor.set_position(2, 0)
    assert_equal(2, buffer.get_cursor_row)
  end

  def test_get_cursor_col
    buffer = Buffer.new('test')
    buffer.cursor.set_position(0, 2)
    assert_equal(2, buffer.get_cursor_col)
  end

  def test_get_char
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    buffer.point.set_point(0, 0)
    assert_equal('a', buffer.get_char)
    buffer.point.set_point(0, 2)
    assert_equal('c', buffer.get_char)
  end

  def test_get_string
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    buffer.point.set_point(0, 0)
    assert_equal('abc', buffer.get_string(3))
    assert_equal('ab', buffer.get_string(2))
    buffer.point.set_point(0, 1)
    assert_equal('bc', buffer.get_string(2))
  end

  def test_get_content
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('def')
    assert_equal("abc\ndef", buffer.get_content)
  end

  def test_insert_char_first
    buffer = Buffer.new('test')
    assert_equal(true, buffer.insert_char('a'))
    assert_equal('a', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(1, buffer.point.col)
    assert_equal(1, buffer.num_chars)
    assert_equal(true, buffer.is_modified)
  end

  def test_insert_char_second
    buffer = Buffer.new('test')
    buffer.insert_char('a')
    assert_equal(true, buffer.insert_char('b'))
    assert_equal('ab', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(2, buffer.point.col)
    assert_equal(2, buffer.num_chars)
  end

  def test_insert_string_first
    buffer = Buffer.new('test')
    assert_equal(true, buffer.insert_string('abc'))
    assert_equal('abc', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(3, buffer.num_chars)
    assert_equal(true, buffer.is_modified)
  end

  def test_insert_string_second
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    assert_equal(true, buffer.insert_string('def'))
    assert_equal('abcdef', buffer.get_content)
    assert_equal(0, buffer.point.row)
    assert_equal(6, buffer.point.col)
    assert_equal(6, buffer.num_chars)
  end

  def test_delete_char
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
    assert_equal(false, buffer.modified?)
  end

  def test_modified_false
    buffer = Buffer.new('test')
    buffer.insert_char('a')
    assert_equal(true, buffer.modified?)
  end

  def test_move_point_default
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('xyz')
    buffer.move_point(-1)
    assert_equal(2, buffer.move_point(2))
    assert_equal(1, buffer.point.row)
    assert_equal(2, buffer.point.col)
    assert_equal(1, buffer.cursor.row)
    assert_equal(2, buffer.cursor.col)
  end

  def test_move_line_default
    buffer = Buffer.new('test')
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
    assert_equal(2, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_move_line_target
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
    buffer.insert_string('abc')
    buffer.change_line
    buffer.insert_string('defg')
    buffer.change_line
    buffer.insert_string('hijk')
    buffer.change_line
    buffer.insert_string('lmn')
    buffer.move_line(-1)
    assert_equal(2, buffer.move_line(2))
    assert_equal(2, buffer.point.row)
    assert_equal(3, buffer.point.col)
    assert_equal(2, buffer.cursor.row)
    assert_equal(3, buffer.cursor.col)
  end

  def test_change_line
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    assert_equal(3, buffer.point.col)
  end

  def test_delete_line_middle
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    assert_equal("bcd\n", buffer.clipboard.content.join)
  end

  def test_paste_string2
    buffer = Buffer.new('test')
    buffer.insert_string('abcd')
    buffer.change_line
    buffer.copy_mark.set_location(0, 1)
    buffer.copy
    buffer.paste_string
    assert_equal("abcd\nbcd\n", buffer.get_content)
  end

  def test_paste_string
    buffer = Buffer.new('test')
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
    buffer = Buffer.new('test')
    buffer.insert_string('1 + 1')
    buffer.store_select(buffer.evaluate_mark, buffer.evaluate)
    assert_equal("1 + 1", buffer.evaluate.content[0])

    buffer.change_line
    buffer.insert_string('puts "a"')
    buffer.store_select(buffer.evaluate_mark, buffer.evaluate)
    assert_equal('1 + 1puts "a"', buffer.evaluate.content.join)
  end

  def test_eval_content
    buffer = Buffer.new('test')
    buffer.insert_string('1 + 1')
    assert_equal(2, buffer.eval_content)
  end

  def test_eval_content
    buffer = Buffer.new('test')
    buffer.insert_string('1 + 1')
    buffer.insert_string(' ')
    buffer.insert_evaluated_content_comment
    assert_equal('1 + 1 # => 2', buffer.content.to_string)
  end


end

MTest::Unit.new.run
