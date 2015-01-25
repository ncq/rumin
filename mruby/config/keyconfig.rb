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

bind %w(ctrl-x ctrl-p) do |b|
	b.move_line -1
end

bind %w(ctrl-x ctrl-n) do |b|
	b.move_line 1
end

bind %w(ctrl-x ctrl-b) do |b|
	b.move_point -1
end

bind %w(ctrl-x ctrl-f) do |b|
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
