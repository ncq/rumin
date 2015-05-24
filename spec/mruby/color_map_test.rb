class ColorMapTest < MTest::Unit::TestCase
  require './mruby/color_map'

  def test_initialize
    content = [
      'abcd',
      'efg'
    ]
    color_map = ColorMap.new(content)
    assert_equal([[0,0,0,0],[0,0,0]], color_map.color_map)
  end

  def test_add
    color_map = ColorMap.new(['ab'])
    # add first
    assert_true(color_map.add(1, 0, 0, 0, 1))
    assert_equal([[1, 1, 0, 0]], color_map.color_map)
    # add middle
    assert_true(color_map.add(2, 0, 2, 0, 3))
    assert_equal([[1, 1, 2, 2, 0, 0]], color_map.color_map)
    # add last
    assert_true(color_map.add(3, 0, 6, 0, 7))
    assert_equal([[1, 1, 2, 2, 0, 0, 3, 3]], color_map.color_map)
    # multi line
    assert_true(color_map.add(4, 0, 8, 2, 9))
    expect = [
      [1, 1, 2, 2, 0, 0, 3, 3, 4, 4],
      [4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
      [4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
    ]
    assert_equal(expect, color_map.color_map)
    # st_row < e_row
    assert_false(color_map.add(5, 2, 0, 1, 0))
  end

  def test_change
    color_map = ColorMap.new(['abcdefg'])
    # single row
    assert_true(color_map.change(1, 0, 2, 0, 4))
    assert_equal([[0, 0, 1, 1, 1, 0, 0]], color_map.color_map)
    # ed_col > colors.size
    assert_true(color_map.change(1, 0, 5, 0, 8))
    assert_equal([[0, 0, 1, 1, 1, 1, 1]], color_map.color_map)
    # multi line
    color_map = ColorMap.new(['abcd', 'efghij'])
    assert_true(color_map.change(1, 0, 2, 1, 2))
    assert_equal([[0, 0, 1, 1], [1, 1, 1, 0, 0, 0]], color_map.color_map)
    # st_row < ed_row
    assert_false(color_map.change(1, 1, 2, 0, 4))
  end

  def test_delete
    # single row
    color_map = ColorMap.new(['abcdefg'])
    assert_true(color_map.change(1, 0, 0, 0, 3))
    assert_true(color_map.delete(0, 2, 0, 4))
    assert_equal([[1, 1, 0, 0]], color_map.color_map)
    # ed_col > colors.size
    assert_true(color_map.delete(0, 2, 0, 4))
    assert_equal([[1, 1]], color_map.color_map)
    # multi line
    color_map = ColorMap.new(['abcd', 'efghij'])
    assert_true(color_map.change(1, 0, 1, 1, 4))
    assert_true(color_map.delete(0, 2, 1, 3))
    assert_equal([[0, 1], [1, 0]], color_map.color_map)
    # st_row < ed_row
    assert_false(color_map.delete(1, 2, 0, 3))
  end

  def test_delete_line
    color_map = ColorMap.new(['abc', 'defg', 'hij'])
    assert_true(color_map.delete_line(1))
    assert_equal([[0, 0, 0], [0, 0, 0]], color_map.color_map)
    # delete all
    color_map = ColorMap.new(['abc'])
    assert_true(color_map.delete_line(0))
    assert_equal([[]], color_map.color_map)
    # row > size
    assert_false(color_map.delete_line(1))
  end

  def delete_line(row)
    return false if row > @color_map.size
    color_1 = @color_map[0, row]
    color_2 = @color_map[(row + 1), (@color_map.size - row - 1)]
    @color_map = line1 + line2
    @color_map = [[]] if @color_map.size == 0
    true
  end

  def test_chnage_line
    color_map = ColorMap.new(['abc', 'defg', 'hij'])
    assert_true(color_map.change(1, 1, 0, 1, 3))
    assert_true(color_map.change_line(1, 2))
    assert_equal([[0, 0, 0], [1, 1], [1, 1], [0, 0, 0]], color_map.color_map)
    # col > size
    assert_false(color_map.change_line(3, 4))
    # color map is nil
    assert_false(color_map.change_line(4, 1))
  end

  def test_merge_line
    # single line
    color_map = ColorMap.new(['abc', 'defg'])
    assert_true(color_map.change(1, 1, 0, 1, 3))
    assert_true(color_map.merge_line(-1, 1))
    assert_equal([[0, 0, 0, 1, 1, 1, 1]], color_map.color_map);
    # multi line
    color_map = ColorMap.new(['abc', 'defg', 'hij'])
    assert_true(color_map.change(1, 1, 0, 1, 3))
    assert_true(color_map.change(2, 2, 0, 2, 2))
    assert_equal([[0, 0, 0], [1, 1, 1, 1], [2, 2, 2]], color_map.color_map);
    assert_true(color_map.merge_line(-2, 2))
    assert_equal([[0, 0, 0, 1, 1, 1, 1, 2, 2, 2]], color_map.color_map);
    # count > 0
    color_map = ColorMap.new(['abc', 'defg'])
    assert_false(color_map.merge_line(1, 0))
    # row >= size
    assert_false(color_map.merge_line(-1, 2))
    # new_row < 0
    assert_false(color_map.merge_line(-1, 0))
  end
end

MTest::Unit.new.run
