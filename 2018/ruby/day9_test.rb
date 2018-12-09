require 'minitest/autorun'
require_relative 'day9.rb'

class CircleTest < Minitest::Test
  def test_example_part_one
    input = [10, 1618]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 8317
  end

  def test_part_one
    input = [418, 70769]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 402398
  end

  def test_part_two
    input = [418, 7076900]
    game = Circle.new(input)
    game.play

    assert_equal game.high_score, 8317
  end
end
