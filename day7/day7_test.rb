require 'minitest/autorun'
require_relative 'day7'

# Test cases for Circus class
class CircusTest < Minitest::Test
  def test_bottom_program_example
    input = File.read('example_input.txt').squeeze("\n")
    circus = Circus.new(input)
    circus.find_bottom_program
    assert_equal 'tknk', circus.bottom_program_name
  end

  def test_bottom_program_input
    input = File.read('day7_input.txt').squeeze("\n")
    circus = Circus.new(input)
    circus.find_bottom_program
    assert_equal 'mkxke', circus.bottom_program_name
  end
end
