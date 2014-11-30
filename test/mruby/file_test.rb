class RuminFileTest < MTest::Unit::TestCase
  require './mruby/file'

  def test_initialize
    test_file_path = './test/fixture/test.txt'
    `echo "abc" > #{test_file_path}`
    time = Time.new
    file = RuminFile.new(test_file_path)
    assert_equal(file.file_name, File.expand_path(test_file_path))
    assert_equal(time.to_s, file.last_modified.to_s)
  end

  def test_read
    test_file_path = './test/fixture/test.txt'
    file = RuminFile.new(test_file_path)
    expectation = Array.new
    expectation.push("abc\n")
    assert_equal(expectation, file.read)
  end

  def test_write
    test_file_path = './test/fixture/file_test_write.txt'
    file = RuminFile.new(test_file_path)
    file.write("abc\n")
    expectation = Array.new
    expectation.push("abc\n")
    assert_equal(expectation, file.read)
  end

  def test_is_changed?
    test_file_path = './test/fixture/test.txt'
    file = RuminFile.new(test_file_path)
    assert_equal(false, file.is_changed?)
  end
  
end

MTest::Unit.new.run
