require "minitest/autorun"
require_relative "day2.rb"

class CorruptionChecksumTest < Minitest::Test
  def checker
    checker = CorruptionChecksum.new
  end

  def test_checksum_single_line
    input = "5 1 9 5"
    assert_equal 8, checker.checksum(input)
  end

  def test_checksum_multiple_lines
    input = "5 1 9 5\n7 5 3\n2 4 6 8"
    assert_equal 18, checker.checksum(input)
  end

  def test_division_single_line
    input = "5 9 2 8"
    assert_equal 4, checker.division_checksum(input)
  end

  def test_division_multiple_lines
    input = "5 9 2 8\n9 4 7 3\n3 8 6 5"
    assert_equal 9, checker.division_checksum(input)
  end
end
