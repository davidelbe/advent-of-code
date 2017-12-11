require 'minitest/autorun'
require_relative 'day11'

# Test cases for Hex class
class HexTest < Minitest::Test
  def test_three_steeps_northeast
    h = Hex.new
    h.follow('ne,ne,ne')
    assert_equal 3, h.distance_from_starting_point
    assert_equal 3, h.max_distance
  end

  def test_ne_sw
    h = Hex.new
    h.follow('ne,ne,sw,sw')
    assert_equal 0, h.distance_from_starting_point
    assert_equal 2, h.max_distance
  end

  def test_ne_s
    h = Hex.new
    h.follow('ne,ne,s,s')
    assert_equal 2, h.distance_from_starting_point
    assert_equal 2, h.max_distance
  end

  def test_se_sw
    h = Hex.new
    h.follow('se,sw,se,sw,sw,se,se,se,nw,nw,nw')
    assert_equal 3, h.distance_from_starting_point
    assert_equal 5, h.max_distance
  end

  def test_input
    h = Hex.new
    h.follow(File.read('input.txt'))
    assert_equal 698, h.distance_from_starting_point
    assert_equal 1435, h.max_distance
  end
end
