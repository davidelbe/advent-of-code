require 'minitest/autorun'
require_relative 'day8.rb'

class TreeTest < Minitest::Test
  def test_example_part_one
    input = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'
    calc = Calculator.new(input)

    assert_equal calc.meta_sum, 138
  end

  def test_part_one
    input = File.read('day8.txt')
    calc = Calculator.new(input)

    assert_equal calc.meta_sum, 40_977
  end

  def test_example_part_two
    input = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'
    calc = Calculator.new(input)

    assert_equal calc.value, 66
  end

  def test_part_two
    input = File.read('day8.txt')
    calc = Calculator.new(input)

    assert_equal calc.value, 27_490
  end
end

# ('part 1:', 40977)
# ('part 2:', 27490)



