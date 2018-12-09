require 'minitest/autorun'
require_relative 'day9.rb'

# Test that our circle works
class CircleTest < Minitest::Test
  def test_example_part_one
    input = [10, 1618]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 8317
  end

  def test_part_one
    input = [418, 70_769]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 402_398
  end

  def test_part_two
    input = [418, 7_076_900]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 3_426_843_186
  end
end
