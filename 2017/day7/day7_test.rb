require 'minitest/autorun'
require_relative 'day7'

# Test cases for Circus class
class CircusTest < Minitest::Test
  def test_bottom_program_example
    input = File.read('example_input.txt')
    circus = Circus.new(input)
    assert_equal 'tknk', circus.bottom_program_name
  end

  def test_bottom_program_input
    input = File.read('day7_input.txt')
    circus = Circus.new(input)
    assert_equal 'mkxke', circus.bottom_program_name
  end

  def test_weight_of_example_stacks
    circus = Circus.new(File.read('example_input.txt'))
    assert_equal 243, circus.total_weight('fwft')
    assert_equal 251, circus.total_weight('ugml')
    assert_equal 243, circus.total_weight('padx')
    assert_equal 243 + 251 + 243 + 41, circus.total_weight('tknk')
  end

  def test_unbalanced_example
    input = File.read('example_input.txt')
    circus = Circus.new(input)
    assert_equal 60, circus.find_unbalanced([circus.bottom_program_name])
  end

  def test_unbalanced
    input = File.read('day7_input.txt')
    circus = Circus.new(input)
    assert_equal 268, circus.find_unbalanced([circus.bottom_program_name])
  end
end
