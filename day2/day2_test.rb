require "minitest/autorun"
require_relative "day2.rb"

class CorruptionChecksumTest < Minitest::Test
  def test_checksum_single_line
    input = "5 1 9 5"
    checker = CorruptionChecksum.new
    assert_equal 8, checker.checksum(input)
  end

  def test_checksum_multiple_lines
    input = "5 1 9 5\n7 5 3\n2 4 6 8"
    checker = CorruptionChecksum.new
    assert_equal 18, checker.checksum(input)
  end
end
