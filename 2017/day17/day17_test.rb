require 'minitest/autorun'
require_relative 'day17'

# Test cases for Spinlock class
class SpinlockTest < Minitest::Test
  def test_example_input
    s = Spinlock.new(3)
    s.spin!(2017)
    assert_equal 638, s.output
  end

  def test_part_one
    s = Spinlock.new(301)
    s.spin!(2017)
    assert_equal 1642, s.output
  end

  def test_part_two
    s = Spinlock.new(301)
    assert_equal 33_601_318, s.spin_fast(50_000_000)
  end
end
