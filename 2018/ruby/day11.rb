require 'pry'
class FuelCell
  attr_accessor :grid, :x, :y, :grid, :combined_power_level
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
    hundred_digit(((rack_id * y) + grid.serial_number) * rack_id) - 5
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
end

class Grid
  attr_accessor :serial_number, :fuel_cells
  def initialize(input)
    self.serial_number = input.to_i
    self.fuel_cells = []
    build_fuel_cells
  end

  def build_fuel_cells
    (1..300).each do |row|
      fuel_cells[row] = [] if fuel_cells[row].nil?
      (1..300).each do |col|
        fuel_cells[row][col] = FuelCell.new(self, col, row)
      end
    end
  end

  def fuel_cell_at(x, y)
    fuel_cells[y][x]
  rescue
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
    # For grid serial number 18, the largest total 3x3 square
    # has a top-left corner of 33,45
    grid = Grid.new(3463)
    largest = grid.largest_square
    assert_equal [235, 60], [largest.top_left_corner.x, largest.top_left_corner.y]
  end
end
