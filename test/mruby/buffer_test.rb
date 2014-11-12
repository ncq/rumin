class PointTest < MTest::Unit::TestCase
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
end

MTest::Unit.new.run
