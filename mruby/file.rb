class RuminFile
	@file
	attr_reader :file_name, :last_modified

	def initialize path, mode
		@file = File.open path, mode
		@file_name = @file.path
		@last_modified = @file.mtime
	end

	def write buff
		if @last_modified != @file.mtime then
			raise "conflicted with other process."
		end
		@file.write buff
		@file.fsync
		@last_modified = @file.mtime
	end

	def read
		@file.fsync
		@file.rewind
		lines = @file.readlines
	end

	def close
		@file.close
	end
end
