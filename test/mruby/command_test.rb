class CommandTest < MTest::Unit::TestCase
  require './mruby/command'
  def test_initialize
    pass('Command class is provisional implementation.')
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
