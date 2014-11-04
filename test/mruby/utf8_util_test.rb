class Utf8UtilTest < MTest::Unit::TestCase
  require './mruby/utf8_util'

  def test_convert_utf_code
    # a
    assert_equal(61, Utf8Util::convert_utf_code([61]))
    # ±
    assert_equal(177, Utf8Util::convert_utf_code([194, 177]))
    # あ
    assert_equal(12354, Utf8Util::convert_utf_code([227, 129, 130]))
    # 4バイト文字の文字コードが不明
    assert_equal(266305, Utf8Util::convert_utf_code([241, 129, 129, 129]))
  end

  def test_full_width?
    assert_equal(false, Utf8Util::full_width?('a'))
    assert_equal(true, Utf8Util::full_width?('あ'))
    assert_equal(false, Utf8Util::full_width?('ｱ'))
  end
end

MTest::Unit.new.run
