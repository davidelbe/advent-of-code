# Grid construction
class Grid
  attr_accessor :coordinates, :grid, :slightly_larger, :input, :max_distance

  def initialize(string, slightly_larger = false, max_distance = 0)
    self.input = string
    self.slightly_larger = slightly_larger
    self.max_distance = max_distance
    self.coordinates = string.split("\n").map do |pair|
      pair.split(', ').map(&:to_i)
    end
  end

  def max_grid_size
    coordinates.flatten.max
  end

  def largest_area
    comparison = slightly_larger_area_values

    values.reject do |key, value|
      key == '.' || comparison[key] != value
    end.values.max
  end

  # Expanding the area a little bit shows which areas
  # are infinite, since they will increase in size
  def slightly_larger_area_values
    comparison_grid = Grid.new(input, true)
    comparison_grid.generate
    comparison_grid.values
  end

  def values
    grid.flatten.flatten.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  end

  def place_coordinates
    coordinates.each_with_index do |c, index|
      grid[c.first][c.last] = index
    end
  end

  def region_size
    generate
    region_count = 0

    grid.each_with_index do |row, y|
      row.each_with_index do |_col, x|
        distance_sum = 0
        coordinates.each do |c|
          distance_sum += manhattan(c, [x, y])
        end
        next if distance_sum >= max_distance

        region_count += 1
      end
    end
    region_count
  end

  def closest_coordinate_to(col, row)
    candidates = []
    min_distance = 999_999_999
    coordinates.each_with_index do |c, index|
      distance = manhattan(c, [row, col])
      if distance < min_distance
        min_distance = distance
        candidates = [index]
      elsif distance == min_distance
        candidates << index
      end
    end
    candidates.size > 1 ? '.' : candidates.first
  end

  def starting_point
    slightly_larger ? 0 : 1
  end

  def end_point
    slightly_larger ? max_grid_size + 4 : max_grid_size + 5
  end

  def generate
    g = []
    starting_point.upto(end_point).each do |row|
      g[row] = []
      starting_point.upto(end_point).each do |col|
        g[row][col] = closest_coordinate_to(row, col)
      end
    end
    self.grid = g
  end

  def manhattan(pt1, pt2)
    (pt1[0] - pt2[0]).abs + (pt1[1] - pt2[1]).abs
  end
end
