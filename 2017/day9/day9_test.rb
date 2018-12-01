require 'minitest/autorun'
require_relative 'day9'

class StreamTest < Minitest::Test
  def test_ignored_clean
    s = Stream.new('{{<!>},{<!>},{<!>},{<a>}}')
    assert_equal s.stream, '{{<},{<},{<},{<a>}}'
  end

  def test_garbage_clean
    s = Stream.new('{{<!>},{<!>},{<!>},{<a>}}')
    assert_equal s.clean!, '{{}}'
  end

  def test_scores
    input = ['{}', '{{{}}}', '{{},{}}', '{{{},{},{{}}}}', '{<a>,<a>,<a>,<a>}',
             '{{<ab>},{<ab>},{<ab>},{<ab>}}', '{{<!!>},{<!!>},{<!!>},{<!!>}}',
             '{{<a!>},{<a!>},{<a!>},{<ab>}}']
    expected_scores = [1, 6, 5, 16, 1, 9, 9, 3]
    input.each_with_index do |i, index|
      s = Stream.new(i)
      s.clean!
      assert_equal expected_scores[index], s.score
    end
  end

  def test_real_input_part_1
    input = File.read('input.txt')
    s = Stream.new(input)
    s.clean!
    assert_equal 11_089, s.score
  end

  def test_garbage_removal_count
    s = Stream.new(File.read('input.txt'))
    before = s.stream.chars.size
    s.clean!('<>')
    after = s.stream.chars.size
    assert_equal 5_288, before - after
  end
end
