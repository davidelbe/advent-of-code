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
    assert_equal 37_230, knot.checksum
  end

  def test_dense_hash_aoc_2017
    knot = Knot.new((0..255).to_a)
    knot.fold_string('AoC 2017')
    assert_equal '33efeb34ea91902bb2f59c9920caa6cd', knot.dense_hash
  end

  def test_dense_hash_123
    knot = Knot.new((0..255).to_a)
    knot.fold_string('1,2,3')
    assert_equal '3efbe78a8d82f29979031a4aa0b16a9d', knot.dense_hash
  end

  def test_dense_hash_124
    knot = Knot.new((0..255).to_a)
    knot.fold_string('1,2,4')
    assert_equal '63960835bcdc130f0b66d7ff4f6a5a8e', knot.dense_hash
  end

  def test_input_part_2
    knot = Knot.new((0..255).to_a)
    knot.fold_string('147,37,249,1,31,2,226,0,161,71,254,243,183,255,30,70')
    assert_equal '70b856a24d586194331398c7fcfa0aaf', knot.dense_hash
  end
end
