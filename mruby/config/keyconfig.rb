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

bind 'ctrl-g' do |b|
  # Qiitan::Client.new(b).post
  debug Qiitan::Client.new(b).post
end

bind 'ctrl-[' do |b|
  b.display.echo.print_message(b.display.echo.get_parameter("input string:"))
end

