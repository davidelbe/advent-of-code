require 'byebug'
class Intcode
  attr_accessor :addresses, :position, :current_instruction, :input, :retval
  def initialize(instructions)
    self.addresses = instructions.split(",").map(&:to_i)
    self.retval = nil
    self.position = 0
    self.input = 5
  end

  def run
    self.current_instruction = Instruction.new(current_value)
    # puts "#{position} => #{current_value} (opcode: #{current_instruction.opcode})"
    # puts "#{addresses[position, 5]}"
    # exit "#{current_instruction.opcode}" unless [1, 2, 3, 4, 5, 6, 7, 8, 99].include?(current_instruction.opcode)
    return retval if finished?

    opcode_one
    opcode_two
    opcode_three
    opcode_four
    opcode_five
    opcode_six
    opcode_seven
    opcode_eight

    run
  end

  def opcode_one
    return unless current_instruction.opcode == 1
    self.addresses[overwrite] = result
    self.position = position + 4
  end

  def opcode_two
    return unless current_instruction.opcode == 2
    self.addresses[overwrite] = result
    self.position = position + 4
  end

  def opcode_three
    return unless current_instruction.opcode == 3
    self.addresses[addresses[position + 1]] = input
    self.position = position + 2
  end

  def opcode_four
    return unless current_instruction.opcode == 4
    self.retval = addresses[addresses[position + 1]]
    puts "Output: #{retval}"
    self.position = position + 2
  end

  def opcode_five
    return unless current_instruction.opcode == 5

    if values.first != 0
      self.position = values.last
    else
      self.position = position + 3
    end
  end

  def opcode_six
    return unless current_instruction.opcode == 6
    if values.first == 0
      self.position = values.last
    else
      self.position = position + 3
    end
  end

  def opcode_seven
    return unless current_instruction.opcode == 7
    val = values.first < values.last ? 1 : 0
    self.addresses[overwrite] = val
    self.position = position + 4
  end

  def opcode_eight
    return unless current_instruction.opcode == 8
    val = values.first == values.last ? 1 : 0
    self.addresses[overwrite] = val
    self.position = position + 4
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
  def initialize(str)
    self.string = str.to_s.rjust(5, '0')
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
  def test_code
    int = Intcode.new('3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9')
    assert_equal 1, int.run
  end
end

program = Intcode.new(File.read('input.txt'))
puts "== Part 2, Day 5, 2019"
program.run
