class DeleteCommand
  class << self
    def buffer_delete(buffer)
      buffer.delete(-1)
    end
  end
end
