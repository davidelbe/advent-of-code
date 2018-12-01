require 'minitest/autorun'
require_relative 'day16'

# Test cases for Dance class
class DanceTest < Minitest::Test
  # s1, a spin of size 1: eabcd.
  # x3/4, swapping the last two programs: eabdc.
  # pe/b, swapping programs e and b: baedc.
  def test_example_instructions_part_one
    dance = Dance.new('abcde')
    dance.instructions = 's1,x3/4,pe/b'
    dance.perform!
    assert_equal 'baedc', dance.output
  end

  def test_part_one
    dance = Dance.new('abcdefghijklmnop')
    dance.instructions = File.read('input.txt')
    dance.perform!
    assert_equal 'ehdpincaogkblmfj', dance.output
  end

  def test_part_two
    dance = Dance.new('abcdefghijklmnop')
    dance.instructions = File.read('input.txt')
    dance.perform_n_times(1_000_000_000)
    assert_equal 'bpcekomfgjdlinha', dance.output
  end
end
