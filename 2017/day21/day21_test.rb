require 'minitest/autorun'
require_relative 'day21'

# Test cases for Art class
class ArtTest < Minitest::Test
  def test_initial_pattern
    skip
    a = Art.new
    assert_equal a.pattern, '.#./..#/###'
    assert_equal 5, a.on_count
    assert_equal 3, a.size
  end

  def test_break_into_2x2
    a = Art.new
    a.pattern = '#..#/..../..../#..#'
    assert_equal ['#./..', '.#/..', '../#.', '../.#'], a.break_into_2x2_squares
  end

  def test_break_into_3x3
    a = Art.new
    a.pattern = '1112223333/111222333/111222333/444555666/444555666/444555666/777888999/777888999/777888999'
    assert_equal ['111/111/111', '222,222/222', '333/333/333', '444/444/444', '555/555/555'], a.break_into_3x3_squares
  end

  def test_example_rules
    a = Art.new(File.read('example.txt'))
    a.enhance!
    assert_equal '#..#/..../..../#..#', a.pattern
    a.enhance!
    assert_equal 12, a.on_count
    assert_equal '##.##./#..#../....../##.##./#..#../......', a.pattern
  end

  def test_mirror
    skip
    a = Art.new
    assert_equal '.#/#.', a.mirror('#./.#')
    assert_equal '#../..#/#..', a.mirror('..#/#../..#')
  end

  def test_rotate_90
    skip
    a = Art.new
    assert_equal '.#/#.', a.rotate90('#./.#')
  end

  # 97 was wrong
  # 108 was wrong
  # 139 was wrong
  def test_part_one
    skip
    a = Art.new(File.read('input.txt'))
    5.times do
      a.enhance!
    end
    assert_equal 1, a.on_count
  end
end
