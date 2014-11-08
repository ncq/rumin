class RuminFileTest < MTest::Unit::TestCase
  require './mruby/file'

  @@test_path = './test/fixture/file_test.txt'
  @@test_file = 'file_test.txt'

  def test_initialize
    file = RuminFile.new(@@test_path)
    assert_equal(@@test_file, file.file_name)
    path = File.expand_path(@@test_path)
    stat = File::Stat.new(path)
    assert_equal(stat.mtime, file.last_modified)
  end

  def test_read
    file = RuminFile.new(@@test_path)
    assert_equal(["test\n"], file.read)
  end

  def test_write
    file = RuminFile.new(@@test_path)
    file.write("test2\n")
    assert_equal(["test2\n"], file.read)
    path = File.expand_path(@@test_path)
    stat = File::Stat.new(path)
    assert_equal(stat.mtime, file.last_modified)
  end

  def teardown
    file = RuminFile.new(@@test_path)
    file.write("test\n")
  end

end

MTest::Unit.new.run
