class RuminFile
	attr_reader :path, :file_name, :last_modified

	def initialize path
		@path = File.expand_path path
		file = File.open @path, "r"
		stat = File::Stat.new(@path)
		@file_name = File.basename @path
		@last_modified = stat.mtime
		file.close
	end

	def write buff
		file = File.open @path, "w"
		file.write buff
		stat = File::Stat.new(@path)
		@last_modified = stat.mtime
		file.close
	end

	def read
		file    = File.open @path, "r"
		content = file.readlines
		file.close
		content
	end
end
