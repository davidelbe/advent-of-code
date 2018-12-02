require 'minitest/autorun'
require_relative 'day2.rb'

# test Checksum
class ChecksumTest < Minitest::Test
  def test_occurrencies
    c = Checksum.new('')
    assert_equal true, c.ocurrencies('abbba', 2)
    assert_equal true, c.ocurrencies('abbba', 3)
    assert_equal false, c.ocurrencies('aba', 3)
  end

  def test_checksum_input
    input = "abba\nabbba\nbcca\nabcd"
    c = Checksum.new(input)
    assert_equal 3, c.checksum
  end

  def test_count_both
    input = "bababc"
    c = Checksum.new(input)
    c.checksum
    assert_equal 1, c.twosomes
    assert_equal 1, c.threesomes
  end

  def test_part_one
    input = File.read('day2.txt')
    c = Checksum.new(input)
    assert_equal 5_904, c.checksum
  end

  def test_line_diff_count
    c = Checksum.new('')
    assert_equal 1, c.line_diff_count('fghij', 'fguij')
    assert_equal 1, c.line_diff_count('abcdef', 'abfdef')
  end

  def test_common_letters
    input = %w[abcde klmno fghij pqrst fguij axcye wvxyz]
    c = Checksum.new(input.join("\n"))
    assert_equal 'fgij', c.common_letters
  end

  def test_false_positive
    input = %w[jiwamotqgcfnudclzbyxkzmrvp jinamojqgsftudclzbyxkhervp jipamotqgcfnudclzbyxkzmrvr jiwamotqgcfnudclzbyxkzmrvr]
    c = Checksum.new(input.join("\n"))
    assert_equal 'jiwamotqgcfnudclzbyxkzmrv', c.common_letters
  end

  def test_part_two
    c = Checksum.new(File.read('day2.txt'))
    assert_equal 'jiwamotgsfrudclzbyzkhlrvp', c.common_letters
  end
end
