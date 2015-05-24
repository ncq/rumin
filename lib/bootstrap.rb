# -*- coding: utf-8 -*-

require "curses"
require "editor"
require "command"

module Rumin
  class Application
    module Bootstrap
      editor = Editor.new
      buffer = rumin.buffer
      display = rumin.display

      command = Command.new

      keys = Array.new
      ret = 1

      while 1
        input_key keys
        ret = command.evaluate buffer

        if ret == 0 then
          break
        end

        display.redisplay
      end

      display.finish
    end
  end

  def input_key(keys)
    key = Curses.getch
    keys.clear
    keys.push(key)
    if key >= 192 && key <= 223 then
      keys.push Curses.getch
    else if key >= 224 && key <= 239 then
      keys.push Curses.getch
      keys.push Curses.getch
    else if key >= 240 && key <= 255 then
      keys.push Curses.getch
      keys.push Curses.getch
      keys.push Curses.getch
    end
  end
end
