class EchoTest < MTest::Unit::TestCase
  require './mruby/echo_line'

  def test_initialize
    echo = Echo.new
    assert_equal('echo', echo.line)
  end

  def test_set_echo
    echo = Echo.new
    assert_equal('echo', echo.line)
    echo.line = 'h'
    assert_equal('h', echo.line)
  end
end

MTest::Unit.new.run
