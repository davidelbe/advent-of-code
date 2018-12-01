require 'minitest/autorun'
require_relative 'day13'

# Test cases for day 13
class ScannerTest < Minitest::Test
  def test_example_trip
    scanner = Scanner.new(File.read('example_input.txt'))
    scanner.make_trip
    assert_equal 6, scanner.max_number
    assert_equal 24, scanner.severity
  end

  def test_example_delay
    scanner = Scanner.new(File.read('example_input.txt'))
    assert_equal 10, scanner.optimal_delay
  end

  def test_part_one
    scanner = Scanner.new(File.read('input.txt'))
    scanner.make_trip
    assert_equal 98, scanner.max_number
    assert_equal 2508, scanner.severity
  end

  def test_part_two
    scanner = Scanner.new(File.read('input.txt'))
    assert_equal 3_913_186, scanner.optimal_delay
  end
end
