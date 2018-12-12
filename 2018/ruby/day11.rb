require 'pry'
class FuelCell
  attr_accessor :grid, :x, :y, :combined_power_level
  def initialize(grid, x, y)
    self.grid = grid
    self.x = x
    self.y = y
  end

  def top_left_corner
    grid.fuel_cell_at(x - 1, y - 1)
  end

  # Find the fuel cell's rack ID, which is its X coordinate plus 10.
  # Begin with a power level of the rack ID times the Y coordinate.
  # Increase the power level by the value of the grid serial number (your puzzle input).
  # Set the power level to itself multiplied by the rack ID.
  # Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
  # Subtract 5 from the power level.
  def power_level
    @power_level ||= hundred_digit(((rack_id * y) + grid.serial_number) * rack_id) - 5
  end

  def power_level=(input)
    @power_level = input.to_i
  end

  def rack_id
    x + 10
  end

  def combined_power_level
    @cpl ||= neighbours.map(&:power_level).sum + power_level
  end

  def neighbours
    positions = [[x - 1, y], [x + 1, y], [x - 1, y - 1],
                 [x, y - 1], [x + 1, y - 1], [x - 1, y + 1],
                 [x, y + 1], [x + 1, y + 1]]
    positions.map do |position|
      grid.fuel_cell_at(position.first, position.last)
    end.compact
  end

  def hundred_digit(number)
    (number.to_i / 100) % 10
  end

  def summed_area
    return power_level if x == 1 && y == 1
    return @summed_area unless @summed_area.nil?

    sum = power_level
    sum += grid.fuel_cell_at(x - 1, y).summed_area if x > 1
    sum += grid.fuel_cell_at(x, y - 1).summed_area if y > 1
    sum -= grid.fuel_cell_at(x - 1, y - 1).summed_area if x > 1 && y > 1
    @summed_area = sum
  end
end
# -10440 a -13071 d -12574 b -10989 c
class Grid
  attr_accessor :serial_number, :fuel_cells
  def initialize(input)
    self.serial_number = input.to_i
    self.fuel_cells = []
    build_fuel_cells
  end

  def summed_area(x, y, size)
    # return 0 if x < 1 || y < 1
    return fuel_cell_at(x, y).power_level if size == 1

    x0 = x - 1
    y0 = y - 1
    x1 = x + size - 1
    y1 = y + size - 1
    a = fuel_cell_at(x0, y0)&.summed_area
    b = fuel_cell_at(x1, y0)&.summed_area
    c = fuel_cell_at(x0, y1)&.summed_area
    d = fuel_cell_at(x1, y1)&.summed_area
    d.to_i - b.to_i - c.to_i + a.to_i
  end

  # -2 -2  -1      -2 -4 -5
  # -1  0  0       -3 -5 -6
  #  0   1  2

  def build_fuel_cells
    (1..300).each do |row|
      fuel_cells[row] = [] if fuel_cells[row].nil?
      (1..300).each do |col|
        fuel_cells[row][col] = FuelCell.new(self, col, row)
      end
    end
  end

  def fuel_cell_at(x, y)
    f = fuel_cells[y][x]
  rescue StandardError
    nil
  end

  def largest_square
    largest_square = nil
    (1..300).each do |row|
      (1..300).each do |col|
        cell = fuel_cell_at(col, row)
        largest_square = cell if largest_square.nil?
        largest_square = cell if largest_square.combined_power_level < cell.combined_power_level
      end
    end
    largest_square
  end

  def largest_total_square
    largest_area = 0
    answer = [nil, nil, nil]
    (1..300).each do |y|
      (1..300).each do |x|
        (1..300).each do |size|
          next if size + y > 300
          next if size + x > 300
          area = summed_area(x, y, size)
          if area > largest_area
            puts "Largest so far => #{largest_area} by #{answer.join(',')}"
            largest_area = area
            answer = [x, y, size]
          end
        end
      end
    end
    answer
  end
end

require 'minitest/autorun'
class FuelCellTest < Minitest::Test
  # For example, to find the power level of the fuel cell at 3,5
  # in a grid with serial number 8 ...
  # So, the power level of this fuel cell is 4.
  def test_power_levels
    grid = Grid.new(8)
    assert_equal 4, grid.fuel_cell_at(3, 5).power_level

    # Fuel cell at  122,79, grid serial number 57: power level -5
    grid = Grid.new(57)
    assert_equal(-5, grid.fuel_cell_at(122, 79).power_level)

    # Fuel cell at 217,196, grid serial number 39: power level  0
    grid = Grid.new(39)
    assert_equal 0, grid.fuel_cell_at(217, 196).power_level

    # Fuel cell at 101,153, grid serial number 71: power level  4.
    grid = Grid.new(71)
    assert_equal 4, grid.fuel_cell_at(101, 153).power_level
  end

  def test_largest_square
    # For grid serial number 18, the largest total 3x3 square
    # has a top-left corner of 33,45
    grid = Grid.new(18)
    assert_equal 29, grid.fuel_cell_at(34, 46).combined_power_level
    largest = grid.largest_square
    assert_equal [33, 45], [largest.top_left_corner.x, largest.top_left_corner.y]
  end

  def test_part_one
    grid = Grid.new(3463)
    largest = grid.largest_square
    assert_equal [235, 60], [largest.top_left_corner.x, largest.top_left_corner.y]
  end

  def test_largest_total_square
    grid = Grid.new(18)
    assert_equal 113, grid.summed_area(90, 269, 16)
    assert_equal [90, 269, 16], grid.largest_total_square
  end

  def test_wikipedia_summed_area
    grid = Grid.new(18)
    ary =
    [
      [31, 2, 4, 33, 5, 36],
      [12, 26, 9, 10, 29, 25],
      [13, 17, 21, 22, 20, 18],
      [24, 23, 15, 16, 14, 19],
      [30, 8, 28, 27, 11, 7]
    ]

    (1..5).each do |y|
      (1..6).each do |x|
        fc = FuelCell.new(grid, x, y)
        fc.power_level = ary[y-1][x-1].to_i
        grid.fuel_cells[y][x] = fc
      end
    end

    (1..5).each do |y|
      (1..6).each do |x|
        puts [x, y, grid.fuel_cell_at(x, y).summed_area].join(" | ")
      end
    end

    assert_equal 197, grid.fuel_cell_at(3, 4).summed_area
    assert_equal 76, grid.summed_area(2, 3, 2)
  end

  def test_example_part_two
    # For grid serial number 42, the largest total square (with
    # a total power of 119) is 12x12 and has a top-left corner of
    # 232,251, so its identifier is 232,251,12.

    grid = Grid.new(42)
    assert_equal 119, grid.summed_area(232, 251, 12)
  end

  def test_part_two
    grid = Grid.new(463)
    assert_equal [233, 282, 11], grid.largest_total_square
  end
end
