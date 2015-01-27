# coding: utf-8

bind %w(up) do |b|
	b.move_line -1
end

bind %w(down) do |b|
	b.move_line 1
end

bind %w(left) do |b|
	b.move_point -1
end

bind %w(right) do |b|
	b.move_point 1
end

bind %w(ctrl-p) do |b|
	b.move_line -1
end

bind %w(ctrl-n) do |b|
	b.move_line 1
end

bind %w(ctrl-b) do |b|
	b.move_point -1
end

bind %w(ctrl-f) do |b|
	b.move_point 1
end

bind %w(ctrl-u) do |b|
	b.undo
end

bind %w(enter) do |b|
  b.change_line
end

bind %w(return) do |b|
  b.change_line
end

bind %w(ctrl-j) do |b|
  b.change_line
end

bind %w(ctrl-m) do |b|
  b.change_line
end

bind %w(ctrl-sp) do |b|
  b.set_evaluate_mark # markセット
end

bind %w(ctrl-x ctrl-i) do |b|
  b.insert_evaluated_region_comment # 実行
end

bind %w(ctrl-[) do |b|
  b.display.echo.print_message(b.display.echo.get_parameter("input string:"))
end

bind %w(ctrl-x ctrl-f) do |b|
  b.open_file
end

bind %w(ctrl-x ctrl-s) do |b|
  b.save_file
end

bind %w(ctrl-d) do |b|
  b.move_point 1
  b.delete(-1)
end

bind %w(ctrl-x ctrl-e) do |b|
  b.eval_content
end

bind %w(ctrl-x ctrl-r) do |b|
  b.insert_evaluated_content_comment
end

bind %w(ctrl-x ctrl-l) do |b|
  b.insert_evaluated_line_comment
end
