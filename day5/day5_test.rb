require 'minitest/autorun'
require_relative 'day5'

# Tests for Maze
class MazeTest < Minitest::Test
  def read_input_file
    File
      .read('day5_input.txt')
      .split("\n")
      .reject(&:empty?)
      .collect(&:to_i)
  end

  def test_increments_part_one
    maze = Maze.new([0, 3, 0, 1, -3])
    maze.step_outside(1)
    assert_equal 5, maze.steps
  end

  def test_increments_part_two
    maze = Maze.new([0, 3, 0, 1, -3])
    maze.step_outside(2)
    assert_equal 10, maze.steps
  end

  def test_input_file_part_one
    maze = Maze.new(read_input_file)
    maze.step_outside
    assert_equal 336_905, maze.steps
  end

  def test_input_file_part_two
    maze = Maze.new(read_input_file)
    maze.step_outside(2)
    assert_equal 21_985_262, maze.steps
  end
end
