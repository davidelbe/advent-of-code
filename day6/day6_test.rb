require 'minitest/autorun'
require_relative 'day6'

# Day 6: Memory Reallocation Test
class MemoryTest < Minitest::Test
  def test_memory_reallocation_example
    memory = Memory.new([0, 2, 7, 0])
    memory.reallocate
    assert_equal 5, memory.steps
  end

  def test_memory_reallocate_once
    memory = Memory.new([0, 2, 7, 0])
    memory.reallocate_once
    assert_equal [2, 4, 1, 2], memory.banks
  end

  def test_part_1
    skip
    input = [0, 5, 10, 0, 11, 14, 13, 4, 11, 8, 8, 7, 1, 4, 12, 11]
    memory = Memory.new(input)
    memory.reallocate
    assert_equal 7864, memory.steps
  end

  def test_reallocate_cycle_length
    input = [0, 2, 7, 0]
    memory = Memory.new(input)
    memory.reallocate_cycle
    assert_equal 4, memory.steps
  end

  def test_part_2
    input = [0, 5, 10, 0, 11, 14, 13, 4, 11, 8, 8, 7, 1, 4, 12, 11]
    memory = Memory.new(input)
    memory.reallocate_cycle
    assert_equal 1695, memory.steps
  end
end
