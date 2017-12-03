require "minitest/autorun"
require_relative "day3.rb"

class SpiralMemoryTest < Minitest::Test
  def spiral
    SpiralMemory.new
  end

  def test_distance_to_square_1
    assert_equal 0, spiral.distance_to(1)
  end

  def test_distance_to_square_12
    assert_equal 3, spiral.distance_to(12)
  end

  def test_distance_to_square_23
    assert_equal 2, spiral.distance_to(23)
  end

  def test_distance_to_square_1024
    assert_equal 31, spiral.distance_to(1024)
  end

  def test_distance_to_square_265149
    assert_equal 438, spiral.distance_to(265149)
  end

  def test_value_of_square_1
    assert_equal 1, spiral.value_of(1)
  end

  def test_value_of_square_2
    assert_equal 1, spiral.value_of(2)
  end

  def test_value_of_square_4
    assert_equal 4, spiral.value_of(4)
  end

  def test_value_of_square_5
    assert_equal 5, spiral.value_of(5)
  end

  # This test won't pass, but the program will raise an
  # error with the correct answer.
  def test_value_of_square_265149
    assert_equal 266330, spiral.value_of(265149)
  end

end

