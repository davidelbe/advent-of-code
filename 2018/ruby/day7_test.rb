require 'minitest/autorun'
require_relative 'day7.rb'

# Test of assembly
class AssemblyTest < Minitest::Test
  def test_example_part_one
    a = Assembly.new("Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.")
    assert_equal 'CABDFE', a.solve
  end

  def test_part_one
    a = Assembly.new(File.read('day7.txt'))

    assert_equal a.solve, 'BHMOTUFLCPQKWINZVRXAJDSYEG'
  end
end
