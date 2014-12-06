class RuminFile
  attr_reader :file_name, :last_modified

  def initialize(file_name)
    @file_name = File.expand_path(file_name)
    if FileTest.exist?(file_name) then
      stat = File::Stat.new(@file_name)
      @last_modified = Time.at(stat.mtime)
    end
  end

  def write(content='')
    file = File.open(@file_name, "w")
    file.write(content)
    stat = File::Stat.new(@file_name)
    @last_modified = stat.mtime
    file.close
  end

  def read
    file = File.open(@file_name, "r")
    content = file.readlines
    file.close
    if content == nil then
      return ''
    else
      content
    end
  end

  def is_changed?
    stat = File::Stat.new(@file_name)
    current_modified = Time.at(stat.mtime)
    if @last_modified.to_s == current_modified.to_s then
      return false
    else
      return true
    end
  end
  
end

