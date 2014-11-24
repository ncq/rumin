class ListTest < MTest::Unit::TestCase
  require './mruby/list.rb'

  def test_initialize
  end

  def test_delete_at
    list = LinkedList.new
    list.push("test")
    list.push("test2")
    list.push("test3")
    list.delete_at(1)
  end

end

MTest::Unit.new.run
