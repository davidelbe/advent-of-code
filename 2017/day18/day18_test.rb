require 'minitest/autorun'
require_relative 'day18'

# Test cases for Duet class
class DuetTest < Minitest::Test
  # def test_sample_instructions
  #   d = Duet.new(File.read('example.txt'))
  #   d.parse
  #   assert_equal 4, d.recovered_frequency
  # end

  # def test_part_one
  #   d = Duet.new(File.read('input.txt'))
  #   d.parse
  #   assert_equal 1187, d.recovered_frequency
  # end

  def test_sample_part_two
    input = File.read('input.txt')
    🎷 = Duet.new(input)
    🎸 = Duet.new(input)
    t1 = Thread.new { 🎷.play_with(🎸, 0) }
    t2 = Thread.new { 🎸.play_with(🎷, 1) }
    t1.join
    t2.join
    assert_equal 5969, 🎸.sent
  end
end
