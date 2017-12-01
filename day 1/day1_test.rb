require "minitest/autorun"
require_relative "day1.rb"
class WheelSummarizerTest < Minitest::Test
  def test_1122
    summarizer = WheelSummarizer.new(1122)
    assert_equal 3, summarizer.sum
  end

  def test_1111
    summarizer = WheelSummarizer.new(1111)
    assert_equal 4, summarizer.sum
  end

  def test_1234
    summarizer = WheelSummarizer.new(1234)
    assert_equal 0, summarizer.sum
  end

  def test_91212129
    summarizer = WheelSummarizer.new(91212129)
    assert_equal 9, summarizer.sum
  end

  def test_1212_two_steps_ahead
    summarizer = WheelSummarizer.new(1212)
    assert_equal 6, summarizer.sum(steps_ahead: 2)
  end

  def test_123425_halfway
    summarizer = WheelSummarizer.new(123425)
    assert_equal 4, summarizer.sum(steps_ahead: 123425.to_s.size / 2)
  end
end