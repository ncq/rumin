class RuminFile
	attr_reader :path, :file_name, :last_modified

	def initialize path
		@path = File.expand_path path
		file = File.open @path, "r"
		@file_name = File.basename @path
		@last_modified = file.mtime
		file.close
	end

	def write buff
		file = File.open path, "w"
		file.write buff
		@last_modified = file.mtime
		file.close
	end

	def read
		file = File.open @path, "r"
		file.readlines
	end
end
