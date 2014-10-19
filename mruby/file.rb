class RuminFile
	@file
	attr_reader :file_name, :last_modified

	def initialize path, mode
		@file = File.open path, mode
		@file_name = @file.path
		@last_modified = @file.mtime
	end

	# TODO
	def write buff
		puts buff
		@last_modified = @file.mtime
	end

	# TODO
	def read
		puts "read."
		if @last_modified != @file.mtime then
			puts "changed."
		end
	end
end
