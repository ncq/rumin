bind 'up', 'BufferCommand::up(buffer)'
bind 'down', 'BufferCommand::down(buffer)'
bind 'left', 'BufferCommand::left(buffer)'
bind 'right', 'BufferCommand::right(buffer)'
bind 10, "BufferCommand::change_line(buffer)" # enter
bind 127, "BufferCommand::buffer_delete(buffer)" # delete
bind 8, "BufferCommand::buffer_del2(buffer)" # C-h
