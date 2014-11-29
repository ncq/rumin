# coding: utf-8
class Rumin
  require './mruby/editor'

  attr_reader :editor

  def initialize
    @editor = Editor.new

    # どこに置いていいかわからなかったので、とりあえずここに置かせてください。
    # 邪魔だったら削除してください。
    Kernel.instance_eval do
      define_method :debug do |msg|
        `echo #{msg} >> uesaka.log`
      end
    end

  end
end


