class Rumin
  require './mruby/editor'

  attr_reader :editor

  def initialize
    @editor = Editor.new
  end
end
