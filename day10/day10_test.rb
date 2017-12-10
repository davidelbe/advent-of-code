require 'minitest/autorun'
require_relative 'day10'

# Test cases for our knot
class KnotTest < Minitest::Test
  def test_invalid_skip_size
    knot = Knot.new([0, 1, 2, 3, 4])
    assert_equal false, knot.fold(7)
    assert_equal 0, knot.position
  end

  def test_fold_three
    knot = Knot.new([0, 1, 2, 3, 4])
    knot.fold(3)
    assert_equal 1, knot.skip_size
    assert_equal [2, 1, 0, 3, 4], knot.list
    assert_equal 3, knot.position
  end

  def test_fold_example
    knot = Knot.new([0, 1, 2, 3, 4])
    input = [3, 4, 1, 5]
    knot.fold_array(input)
    assert_equal 4, knot.skip_size
    assert_equal 4, knot.position
    assert_equal [3, 4, 2, 1, 0], knot.list
    assert_equal 12, knot.checksum
  end

  def test_input_part_1
    knot = Knot.new((0..255).to_a)
    i = [147, 37, 249, 1, 31, 2, 226, 0, 161, 71, 254, 243, 183, 255, 30, 70]
    knot.fold_array(i)
    assert_equal 37230, knot.checksum
  end
end
