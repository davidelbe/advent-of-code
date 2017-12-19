require 'minitest/autorun'
require_relative 'day19'

# Test cases for Day 19
class TubeTest < Minitest::Test
  def test_example
    t = Tube.new(File.read('example.txt'))
    assert_equal 'ABCDEF', t.letters
    assert_equal 38, t.steps
  end

  def test_input
    t = Tube.new(File.read('input.txt'))
    assert_equal 'XYFDJNRCQA', t.letters
    assert_equal 17_450, t.steps
  end
end
