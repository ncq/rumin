# coding: utf-8
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

# bind 259 do |b|
#   b.move_line -1
# end
#
# bind 258 do |b|
#   b.move_line 1
# end
#
# bind 260 do |b|
#   b.move_point -1
# end
#
# bind 261 do |b|
#   b.move_point 1
# end
#
# bind 10 do |b|
#   b.change_line
# end
#
# bind 127 do |b|
#   b.delete -1
# end
#
# # C-e
# bind 5 do |b|
#   b.eval_content
# end
#
# # C-r
# bind 18 do |b|
#   b.insert_evaluated_content_comment
# end
#
# # C-l
# bind 12 do |b|
#   b.insert_evaluated_line_comment
# end
#
#
# bind 263 do |b|
#   b.delete -1
# end
#
# bind 331 do |b|
#   b.paste_string
# end
#
# bind 266 do |b|
#   b.set_copy_mark
# end
#
# bind 267 do |b|
#   b.copy
# end
#
# # C-p
# bind 16 do |b|
#   b.move_line -1
# end
#
# # C-n
# bind 14 do |b|
#   b.move_line 1
# end
#
# # C-b
# bind 2 do |b|
#   b.move_point -1
# end
#
# # C-f
# bind 4 do |b|
#   b.move_point 1
# end
#
# # C-f
# bind 6 do |b|
#   b.move_point 1
# end
#
# # C-h
# bind 263 do |b|
#   b.delete -1
# end

# キーネームでバインディング対象を指定できる
bind 'up' do |b|
  b.move_line -1
end

bind 'down' do |b|
  b.move_line 1
end

bind 'left' do |b|
  b.move_point -1
end

bind 'right' do |b|
  b.move_point 1
end

bind 'ctrl-p' do |b|
  b.move_line -1
end

bind 'ctrl-n' do |b|
  b.move_line 1
end

bind 'ctrl-f' do |b|
  b.move_point 1
end

bind 'ctrl-b' do |b|
  b.move_point -1
end

bind 'ctrl-j' do |b|
  b.change_line
end

bind 'ctrl-e' do |b|
  b.eval_content
end

bind 'ctrl-r' do |b|
  b.insert_evaluated_content_comment
end

bind 'ctrl-l' do |b|
  b.insert_evaluated_line_comment
end

bind 'ctrl-t' do |b|
  b.set_evaluate_mark # markセット
end

bind 'ctrl-i' do |b|
  b.insert_evaluated_region_comment # 実行
end
