class ColorMap
  attr_reader :color_map

  def initialize(content)
    @color_map = []
    content.each { |line| @color_map << Array.new(line.length, 0) }
  end

  def add(code, st_row, st_col, ed_row, ed_col)
    return false if st_row > ed_row
    diff = ed_row - st_row + 1
    diff.times do |time|
      row    = st_row + time
      colors = @color_map[row]
      if colors.nil?
        @color_map[row] = []
        colors = []
      end
      if row == st_row
        row_st_col = st_col
      else
        row_st_col = 0
      end
      next if row_st_col > colors.size
      next if row_st_col > ed_col
      color_1 = colors[0, row_st_col]
      color_2 = colors[row_st_col, (colors.size - row_st_col)]
      length  = ed_col - row_st_col + 1
      colors  = color_1 + Array.new(length, code) + color_2
      @color_map[row] = colors
    end
    true
  end

  def change(code, st_row, st_col, ed_row, ed_col)
    return false if st_row > ed_row
    diff = ed_row - st_row + 1
    diff.times do |time|
      row    = st_row + time
      colors = @color_map[row]
      next if colors.nil?
      if row == st_row
        row_st_col = st_col
      else
        row_st_col = 0
      end
      if ed_col >= colors.size || row != ed_row
        row_ed_col = colors.size - 1
      else
        row_ed_col = ed_col
      end
      next if row_st_col > colors.size
      next if row_st_col > row_ed_col
      @color_map[row].fill(code, row_st_col, (row_ed_col - row_st_col + 1))
    end
    true
  end

  def delete(st_row, st_col, ed_row, ed_col)
    return false if st_row > ed_row
    diff = ed_row - st_row + 1
    diff.times do |time|
      row = st_row + time
      colors = @color_map[row]
      next if colors.nil?
      if row == st_row
        row_st_col = st_col
      else
        row_st_col = 0
      end
      row_ed_col = ed_col + 1
      next if row_st_col > colors.size
      next if row_st_col > row_ed_col
      color_1 = colors[0, row_st_col]
      color_2 = colors[row_ed_col, (colors.size - row_ed_col)]
      if color_2.nil?
        @color_map[row] = color_1
      else
        @color_map[row] = color_1 + color_2
      end
    end
    true
  end

  def delete_line(row)
    return false if row >= @color_map.size
    color_1 = @color_map[0, row]
    color_2 = @color_map[(row + 1), (@color_map.size - row - 1)]
    @color_map = color_1 + color_2
    @color_map = [[]] if @color_map.size == 0
    true
  end

  def change_line(row, col)
    colors = @color_map[row]
    return false if colors.nil?
    return false if col > colors.size
    color_1 = colors[0, col]
    color_2 = colors[col, (colors.size - col)]
    @color_map[row] = color_1
    map_1 = @color_map[0, (row + 1)]
    map_2 = @color_map[(row + 1), (@color_map.size - row + 1)]
    @color_map = map_1 + [color_2] + map_2
    true
  end

  def merge_line(count, row)
    return false if count > 0
    return false if row >= @color_map.size
    new_row = row + count
    return false if new_row < 0
    merge_line = @color_map[(new_row + 1), count.abs]
    @color_map[new_row] += merge_line.flatten
    content_1 = @color_map[0, (new_row + 1)]
    content_2 = @color_map[(row + 1), (@color_map.size - content_1.size + count)]
    @color_map = content_1 + content_2
    true
  end
end
