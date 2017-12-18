require 'minitest/autorun'
require_relative 'day18'

# Test cases for Duet class
class DuetTest < Minitest::Test
  def test_sample_instructions
    d = Duet.new(File.read('example.txt'))
    d.parse
    assert_equal 4, d.recovered_frequency
  end

  def test_part_one
    d = Duet.new(File.read('input.txt'))
    d.parse
    assert_equal 1187, d.recovered_frequency
  end
end
