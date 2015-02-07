class ContentArrayTest < MTest::Unit::TestCase
  require './mruby/content_array'
  require './mruby/utf8_util'

  def test_initialize
    content_1 = ContentArray.new
    assert_equal([''], content_1.content)
    content_2 = ContentArray.new('abc')
    assert_equal(['abc'], content_2.content)
    content_3 = ContentArray.new(['abc', 'def'])
    assert_equal(['abc', 'def'], content_3.content)
  end

  def test_get_char_success
    content = ContentArray.new(['abc', 'def'])
    assert_equal('b', content.get_char(0, 1))
    assert_equal('f', content.get_char(1, 2))
    assert_equal(nil, content.get_char(1, 4))
    assert_equal(nil, content.get_char(2, 0))
  end

  def test_get_char_fail
    content = ContentArray.new(['abc', 'def'])
    assert_equal(nil, content.get_char(1, 4))
    assert_equal(nil, content.get_char(2, 0))
  end

  def test_get_string_success
    content = ContentArray.new(['abc', 'def'])
    assert_equal('bc', content.get_string(0, 1, 2))
    assert_equal('c', content.get_string(0, 2, 2))
    assert_equal('de', content.get_string(1, 0, 2))
  end

  def test_get_string_fail
    content = ContentArray.new(['abc', 'def'])
    assert_equal(nil, content.get_string(0, 0, 0))
    assert_equal(nil, content.get_string(1, 4, 1))
    assert_equal(nil, content.get_string(2, 0, 1))
  end

  def test_get_line
    content = ContentArray.new(['abc', 'def'])
    assert_equal('abc', content.get_line(0))
    assert_equal('def', content.get_line(1))
    assert_equal(nil, content.get_line(2))
  end

  def test_rows
    content = ContentArray.new(['abc', 'def'])
    assert_equal(2, content.rows)
  end

  def test_insert_char_success
    content = ContentArray.new(['abc', 'def'])
    assert_equal('agbc', content.insert_char('g', 0, 1))
    assert_equal('hdef', content.insert_char('h', 1, 0))
  end

  def test_insert_char_fail
    content = ContentArray.new(['abc', 'def'])
    assert_equal(nil, content.insert_char('i', 1, 5))
    assert_equal(nil, content.insert_char('j', 3, 0))
  end

  def test_insert_string_success
    content = ContentArray.new(['abc', 'def'])
    assert_equal('aghbc', content.insert_string('gh', 0, 1))
    assert_equal('ijkdef', content.insert_string('ijk', 1, 0))
  end

  def test_insert_string_fail
    content = ContentArray.new(['abc', 'def'])
    assert_equal(nil, content.insert_string('lm', 1, 8))
    assert_equal(nil, content.insert_string('no', 3, 0))
  end

  def test_change_line_success
    content = ContentArray.new(['abc', 'def'])
    assert_equal(true, content.change_line(1, 2))
    assert_equal(['abc', 'de', 'f'], content.content)
    assert_equal(true, content.change_line(0, 0))
    assert_equal(['', 'abc', 'de', 'f'], content.content)
  end

  def test_change_line_fail
    content = ContentArray.new(['abc', 'def'])
    assert_equal(false, content.change_line(2, 2))
    assert_equal(false, content.change_line(3, 0))
  end

  def test_delete_line_success
    content = ContentArray.new(['abc', 'def', 'ghi'])
    assert_equal(true, content.delete_line(1))
    assert_equal(['abc', 'ghi'], content.content)
    assert_equal(true, content.delete_line(0))
    assert_equal(['ghi'], content.content)
    assert_equal(true, content.delete_line(0))
    assert_equal([''], content.content)
  end

  def test_delete_line_fail
    content = ContentArray.new(['abc', 'def', 'ghi'])
    assert_equal(false, content.delete_line(4))
    assert_equal(['abc', 'def', 'ghi'], content.content)
  end

  def test_replace_line
    content = ContentArray.new(['abc', 'def'])
    assert_equal(true, content.replace_line(1, 'ghi'))
    assert_equal(['abc', 'ghi'], content.content)
    # assert_equal(false, content.replace_line(2, 'ghi'))
  end

  def test_to_string
    content = ContentArray.new(['abc', 'def'])
    assert_equal("abc\ndef", content.to_string)
  end

  def test_delete_char_success
    content = ContentArray.new(['abcd', 'efgh', 'hijk'])
    assert_equal("ad", content.delete_char(2, 0, 1))
    assert_equal("eh", content.delete_char(-2, 1, 3))
    assert_equal("jk", content.delete_char(-4, 2, 2))
  end

  def test_delete_char_fail
    content = ContentArray.new(['abcd', 'efgh', 'hijk'])
    assert_equal(nil, content.delete_char(0, 0, 1))
    assert_equal(nil, content.delete_char(0, 3, 1))
  end

  def test_merge_line_success
    content = ContentArray.new(['abc', 'def', 'ghi', 'jkl'])
    content.merge_line(-1, 1)
    assert_equal(['abcdef', 'ghi', 'jkl'], content.content)
    content.merge_line(-2, 2)
    assert_equal(['abcdefghijkl'], content.content)
  end

  def test_merge_line_fail
    content = ContentArray.new(['abc', 'def'])
    content.merge_line(1, 1)
    assert_equal(['abc', 'def'], content.content)
    content.merge_line(-2, 1)
    assert_equal(['abc', 'def'], content.content)
  end

  def test_convert_col_point_into_cursor_success
    content = ContentArray.new(['abcいろはdef'])
    assert_equal(2, content.convert_col_point_into_cursor(0, 2, 80))
    assert_equal(9, content.convert_col_point_into_cursor(0, 6, 80))
  end

  def test_convert_col_point_into_cursor_fail
    content = ContentArray.new(['abcいろはdef'])
    assert_equal(nil, content.convert_col_point_into_cursor(0, 10, 80))
    assert_equal(nil, content.convert_col_point_into_cursor(1, 0, 80))
  end

  def test_convert_col_cursor_into_point_success
    content = ContentArray.new(['abcいろはdef'])
    assert_equal(2, content.convert_col_cursor_into_point(0, 2, 2, 80))
    assert_equal(6, content.convert_col_cursor_into_point(0, 6, 9, 80))
  end

  def test_convert_col_cursor_into_point_fail
    content = ContentArray.new(['abcいろはdef'])
    assert_equal(nil, content.convert_col_cursor_into_point(0, 10, 10, 80))
    assert_equal(nil, content.convert_col_cursor_into_point(1, 0, 0, 80))
    assert_equal(nil, content.convert_col_cursor_into_point(0, 4, 6, 80))
  end

  def test_adjust_cursor_col
    content = ContentArray.new(['abcいろはdef', ''])
    assert_equal(5, content.adjust_cursor_col(0, 5, 80))
    assert_equal(5, content.adjust_cursor_col(0, 6, 80))
    assert_equal(12, content.adjust_cursor_col(0, 15, 80))
    assert_equal(0, content.adjust_cursor_col(1, 2, 80))
    assert_equal(0, content.adjust_cursor_col(2, 2, 80))
  end
end

MTest::Unit.new.run
