# coding: utf-8
class Rumin
  require './mruby/editor'


  attr_reader :editor

  def initialize
    @editor = Editor.new
  end
end

Kernel.module_eval do
  def debug(msg)
    open("uesaka.log", "a"){ |f| f.puts msg }
  end
end
