require 'minitest/autorun'
require_relative 'day15'

# Test cases for Judge class
class JudgeTest < Minitest::Test
  def test_matches_with_five_rounds
    judge = Judge.new(65, 8921)
    judge.rounds = 5
    judge.calculate
    assert_equal 1, judge.matches
  end

  def test_matches_example_part_two
    judge = Judge.new(65, 8921)
    judge.rounds = 1056
    judge.picky_calculate
    assert_equal 1, judge.matches
  end

  def test_part_one
    judge = Judge.new(591, 393)
    judge.rounds = 40_000_000
    judge.calculate
    assert_equal 619, judge.matches
  end

  def test_part_two
    judge = Judge.new(591, 393)
    judge.rounds = 5_000_000 # _000
    judge.picky_calculate
    assert_equal 290, judge.matches
  end
end
