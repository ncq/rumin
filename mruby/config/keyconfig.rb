# bind 259, 'BufferCommand::up(buffer)' # up
# bind 258, 'BufferCommand::down(buffer)' # down
# bind 260, 'BufferCommand::left(buffer)' # left
# bind 261, 'BufferCommand::right(buffer)' # right
# bind 10, "BufferCommand::change_line(buffer)" # enter
# bind 127, "BufferCommand::buffer_delete(buffer)" # delete
# bind 8, "BufferCommand::buffer_del2(buffer)" # C-h
# bind 331, "BufferCommand::paste_string(buffer)" # insert
# bind 266, "BufferCommand::set_copy_mark(buffer)" # F2
# bind 267, "BufferCommand::copy(buffer)" # F3

bind 259 do |b|
  b.move_line -1
end

bind 258 do |b|
  b.move_line 1
end

bind 260 do |b|
  b.move_point -1
end

bind 261 do |b|
  b.move_point 1
end

bind 10 do |b|
  b.change_line
end

bind 127 do |b|
  b.delete -1
end

bind 5 do |b|
  b.insert_string(eval(b.content.to_string).to_s)
end

bind 263 do |b|
  b.delete -1
end

bind 331 do |b|
  b.paste_string
end

bind 266 do |b|
  b.set_copy_mark
end

bind 267 do |b|
  b.copy
end

