# -*- coding: utf-8 -*-

require "curses"
require "editor"
require "command"

class Bootstrap
  def input_key(keys)
    key = Curses.getch.ord
    keys.clear
    keys.push(key)

    if key >= 192 && key <= 223 then
      keys.push Curses.getch
    elsif key >= 224 && key <= 239 then
      keys.push Curses.getch
      keys.push Curses.getch
    elsif key >= 240 && key <= 255 then
      keys.push Curses.getch
      keys.push Curses.getch
      keys.push Curses.getch
    end
  end

  def run
    editor = Editor.new
    buffer = editor.current_buffer
    display = editor.display

    command = Command.new

    keys = Array.new
    ret = 1

    while true do
      input_key keys
      ret = command.evaluate(keys, buffer)

      if ret == 0 then
        break
      end

      display.redisplay
    end

    display.finish
  end
end
