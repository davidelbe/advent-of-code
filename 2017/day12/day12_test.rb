require 'minitest/autorun'
require_relative 'day12'

# Test cases for Plumber
class PlumberTest < Minitest::Test
  def example_input
    File.read('input_example.txt')
  end

  def test_example_input
    p = Plumber.new(example_input)
    assert_equal 6, p.connections([0]).size
    assert_equal 1, p.connections([1]).size
    assert_equal 2, p.groups
  end

  def test_real_input
    p = Plumber.new(File.read('input.txt'))
    assert_equal 288, p.connections([0]).size
    assert_equal 211, p.groups
  end
end
