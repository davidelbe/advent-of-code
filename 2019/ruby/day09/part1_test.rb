require 'minitest/autorun'
require 'byebug'

require_relative 'part1.rb'

class Program8Test < Minitest::Test

  def test_day_five
    program = Intcode.new([1], '1,0,0,0,99')
    program.run
    assert_equal [2, 0, 0, 0, 99], program.addresses
  end

  def test_example_one
    program = Intcode.new([1], '1102,34915192,34915192,7,4,7,99,0')
    assert_equal 16, program.run.first.to_s.chars.size 
  end

  def test_example_two
    program = Intcode.new([1], '104,1125899906842624,99')
    program.run
    assert_equal [1125899906842624], program.retval
  end

  def test_example_three
    program = Intcode.new([1, 1, 1, 1], '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99')
    program.run
    assert_equal [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99], program.retval
  end

  def test_less_than_eight
    program = Intcode.new([1], '3,9,7,9,10,9,4,9,99,-1,8')
    assert_equal program.run, [1]
  end

  def test_extra_one
    assert_equal Intcode.new([1], '109,-1,004,1,99').run, [-1]
    assert_equal Intcode.new([1], '109, -1, 104, 1, 99').run, [1]
    assert_equal Intcode.new([1], '109, 5, 204, 0, 99, -10, -11, -12').run, [-10]
  end
end
