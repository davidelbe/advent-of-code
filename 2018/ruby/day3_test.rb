require 'minitest/autorun'
require_relative 'day3.rb'

# test Checksum
class RectangleTest < Minitest::Test
  def test_example_part_one
    claims = ['#1 @ 1,3: 4x4',
              '#2 @ 3,1: 4x4',
              '#3 @ 5,5: 2x2']
    r = Rectangle.new(claims)
    assert_equal 4, r.overlaps_count
  end

  def test_rows_and_cols
    claims = ['#1 @ 1,3: 4x5',
              '#2 @ 3,1: 4x4',
              '#3 @ 5,5: 2x2']
    r = Rectangle.new(claims)
    assert_equal 8, r.rows
    assert_equal 7, r.cols
    assert_equal 56, r.squares.size
  end

  def test_part_one_and_part_two
    input = File.read('day3.txt').split("\n")
    r = Rectangle.new(input)
    assert_equal 118_840, r.overlaps_count
    assert_equal 919, r.no_overlapping_id
  end
end

# Testing a claim
class ClaimTest < Minitest::Test
  def test_claim_parsing
    claim = Claim.new('#123 @ 3,2: 5x4')

    assert_equal 123, claim.id
    assert_equal 3, claim.left
    assert_equal 2, claim.top
    assert_equal 5, claim.width
    assert_equal 4, claim.height
  end

  def test_positions
    claim = Claim.new('#123 @ 1,1: 3x2')
    # 0  1   2    3
    # 4 (5) (6)  (7)
    # 8 (9) (10) (11)
    assert_equal [5, 6, 7, 9, 10, 11], claim.positions(max_width: 4)
  end
end
