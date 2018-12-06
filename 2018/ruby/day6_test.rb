require 'minitest/autorun'
require_relative 'day6.rb'

# Test the Grid
class GridTest < Minitest::Test
  def test_example_part_one
    input = ['1, 1', '1, 6', '8, 3', '3, 4', '5, 5', '8, 9'].join("\n")
    grid = Grid.new(input)

    grid.generate

    assert_equal [[1, 1], [1, 6], [8, 3], [3, 4], [5, 5], [8, 9]],
                 grid.coordinates
    assert_equal 9, grid.max_grid_size
    assert_equal 17, grid.largest_area
  end

  def test_part_one
    input = File.read('day6.txt')
    grid = Grid.new(input)

    grid.generate

    assert_equal 6047, grid.largest_area
  end

  # What is the size of the region containing all locations which have a
  # total distance to all given coordinates of less than 10000?
  def test_example_part_two
    input = ['1, 1', '1, 6', '8, 3', '3, 4', '5, 5', '8, 9'].join("\n")
    grid = Grid.new(input, true, 32)

    assert_equal 16, grid.region_size
  end

  def test_part_two
    input = File.read('day6.txt')
    grid = Grid.new(input, true, 10_000)

    assert_equal 46_320, grid.region_size
  end
end
