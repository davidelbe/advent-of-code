require 'byebug'
class Intcode
  attr_accessor :addresses, :position, :current_instruction
  def initialize(input)
    self.addresses = input.split(",").map(&:to_i)
    self.position = 0
  end

  def run
    self.current_instruction = Instruction.new(current_value)
    byebug unless [1, 2, 3, 4, 99].include?(current_instruction.opcode)
    return addresses.join(",") if finished?

    self.addresses[overwrite] = result if [1, 2].include?(current_instruction.opcode)
    self.addresses[addresses[position + 1]] = 1 if current_instruction.opcode == 3
    puts self.addresses[addresses[position + 1]] if current_instruction.opcode == 4 && self.addresses[addresses[position + 1]] != 0
    self.position = position + number_of_steps

    run
  end

  def finished?
    current_instruction.opcode == 99
  end

  def current_value
    addresses[position]
  end

  def value_of_position(steps = 0, mode = nil)
    mode = current_instruction.parameter_modes[steps - 1]
    mode == 1 ?  addresses[position + steps] : addresses[adressess[position + steps]]
  end

  def mode_based_value(position, mode = 0)
    mode == 1 ?  addresses[position] : addresses[addresses[position]]
  end

  # It is important to remember that the instruction pointer should increase by
  # the number of values in the instruction after the instruction finishes.
  # Because of the new instructions, this amount is no longer always 4.
  def number_of_steps
    case current_instruction.opcode
    when 3, 4
      2
    else
      4
    end
  end

  def result
    return values.first + values.last if current_instruction.opcode == 1
    values.first * values.last
  end

  def values
    [
      mode_based_value(position + 1, current_instruction.parameter_modes[0]),
      mode_based_value(position + 2, current_instruction.parameter_modes[1])
    ]
  end

  def overwrite
    addresses[position + 3]
  end
end

class Instruction
  attr_accessor :string
  def initialize(string)
    self.string = string.to_s.rjust(5, '0')
  end

  def opcode
    string[-2, 2].to_i
  end

  def parameter_modes
    string[0, 3].chars.map(&:to_i).reverse
  end
end

require 'minitest/autorun'
class IntCodeTest < Minitest::Test
  def test_final_state
    assert_equal '2,0,0,0,99', Intcode.new('1,0,0,0,99').run
    assert_equal '30,1,1,4,2,5,6,0,99', Intcode.new('1,1,1,4,99,5,6,0,99').run
    assert_equal '2,4,4,5,99,9801', Intcode.new('2,4,4,5,99,0').run
    assert_equal '1101,100,-1,4,99', Intcode.new('1101,100,-1,4,99').run
    assert_equal '1002,4,3,4,99', Intcode.new('1002,4,3,4,33').run
  end
end

class InstructionTest < Minitest::Test
  def test_opcode
    assert_equal 2, Instruction.new('1002').opcode
    assert_equal 99, Instruction.new('10099').opcode
  end

  def test_parameter_modes
    assert_equal [0, 1, 0], Instruction.new('1002').parameter_modes
    assert_equal [1, 0, 1], Instruction.new('10102').parameter_modes
    assert_equal [1, 1, 0], Instruction.new('01102').parameter_modes
  end
end

program = Intcode.new(File.read('input.txt'))
puts "== Part 1, Day 5, 2019"
program.run
