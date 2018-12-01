require 'minitest/autorun'
require_relative 'day1.rb'

# test FrequencyChange
class FrequencyChangeTest < Minitest::Test
  def test_sum
    fc = FrequencyChange.new
    assert_equal(3, fc.sum('+1, +1, +1'))
    assert_equal(0, fc.sum('+1, +1, -2'))
    assert_equal(-6, fc.sum('-1, -2, -3'))
  end

  # Tests with my real input from part one
  def test_part_one
    input = File.read('day1.txt').split("\n").join(' ')
    fc = FrequencyChange.new
    assert_equal 533, fc.sum(input)
  end

  def test_repeat
    fc = FrequencyChange.new
    assert_equal 0, fc.repeat('+1, -1')
    assert_equal 10, fc.repeat('+3, +3, +4, -2, -4')
    assert_equal 5, fc.repeat('-6, +3, +8, +5, -6')
    assert_equal 14, fc.repeat('+7, +7, -2, -7, -4')
  end

  def test_part_two
    input = File.read('day1.txt').split("\n").join(' ')
    fc = FrequencyChange.new
    assert_equal 73_272, fc.repeat(input)
  end
end
