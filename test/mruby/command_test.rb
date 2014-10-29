class CommandTest < MTest::Unit::TestCase
  require './mruby/command'

  def test_arrow_true
    command = Command.new
    assert_equal(true, command.arrow?([27, 91, 65]))
    assert_equal(true, command.arrow?([27, 91, 66]))
    assert_equal(true, command.arrow?([27, 91, 67]))
    assert_equal(true, command.arrow?([27, 91, 68]))
  end

  def test_arrow_false
    command = Command.new
    assert_equal(false, command.arrow?([27]))
    assert_equal(false, command.arrow?([27, 91]))
    assert_equal(false, command.arrow?([1, 91, 65]))
    assert_equal(false, command.arrow?([27, 1, 65]))
  end

  def test_arrow_vector_success
    command = Command.new
    assert_equal('up', command.arrow_vector([27, 91, 65]))
    assert_equal('down', command.arrow_vector([27, 91, 66]))
    assert_equal('right', command.arrow_vector([27, 91, 67]))
    assert_equal('left', command.arrow_vector([27, 91, 68]))
  end

  def test_arrow_vector_fail
    command = Command.new
    assert_equal(nil, command.arrow_vector([1, 91, 65], true))
    assert_equal(nil, command.arrow_vector([27, 91, 1], false))
  end

  def test_load_command_success
    Command.load_command
    assert !require('./mruby/command/buffer_command.rb')
    assert !require('./mruby/command/plugin/delete_command.rb')
  end

  def test_evaluate_success
  end


end

MTest::Unit.new.run
