class EditorTest < MTest::Unit::TestCase
  require './mruby/editor'

  def teardown
    Curses::endwin
  end

  def test_initialize
    editor = Editor.new
    assert_equal('default', editor.current_buffer.name)
  end

  def test_finish
    editor = Editor.new
    assert_equal(true, editor.finish)
  end

  def test_finish_modified
    editor = Editor.new
    buffer = editor.create_buffer
    buffer.insert_char('a')
    assert_equal(false, editor.finish)
  end

  def test_save
    editor = Editor.new
    buffer = editor.create_buffer
    buffer.set_file_name('./test/fixture/editor_save.txt')
    buffer.insert_char('a')
    assert_equal(true, editor.save)
  end

  def test_load
    editor = Editor.new
    buffer = editor.create_buffer
    test_file_name = './test/fixture/editor_load.txt'
    `touch #{test_file_name}`
    `echo "test" > #{test_file_name}`
    buffer.set_file_name(test_file_name)
    assert_equal(true, editor.load)
    assert_equal("test\n", buffer.get_content)
  end

  def test_create_buffer_nil
    editor = Editor.new
    buffer = editor.create_buffer
    assert_equal('default_1', buffer.name)
  end

  def test_create_buffer_named
    editor = Editor.new
    buffer = editor.create_buffer('test')
    assert_equal('test', buffer.name)
  end

  def test_delete_buffer
    editor = Editor.new
    editor.create_buffer('test')
    assert_equal(true, editor.delete_buffer('test'))
  end

  def test_set_current_buffer
    editor = Editor.new
    editor.create_buffer('test2')
    buffer = editor.set_current_buffer('test2')
    assert_equal('test2', buffer.name)
  end

  def test_get_buffer_list
    editor = Editor.new
    buffer_list = editor.get_buffer_list
    master_list = Array.new
    master_list.push('default')
    assert_equal(master_list, buffer_list)
  end

  def test_print_echo
    editor = Editor.new
    buffer = editor.current_buffer
    assert_equal("fuga", buffer.display.echo.output)
  end

end

MTest::Unit.new.run
