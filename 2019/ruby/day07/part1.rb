require 'byebug'
class Intcode
  attr_accessor :addresses, :position, :current_instruction, :inputs, :retval
  def initialize(inputs = [], instructions)
    self.addresses = instructions.split(",").map(&:to_i)
    self.retval = nil
    self.position = 0
    self.inputs = inputs
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
    self.addresses[addresses[position + 1]] = inputs.first.to_i
    self.inputs = inputs.drop(1)
    self.position = position + 2
  end

  def opcode_four
    return unless current_instruction.opcode == 4
    self.retval = addresses[addresses[position + 1]]
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

class Amplifier
  attr_accessor :input, :output, :program

  def initialize(phase: 0, signal: 0, instructions: "")
    self.program = Intcode.new([phase, signal], instructions)
  end

  def output
    program.run
  end
end

class Program7
  attr_accessor :max_thruster_signal
  def initialize(input)
    self.max_thruster_signal = 0
    all_possible_settings.each do |setting|
      input_signal = 0
      5.times do |i|
        amp = Amplifier.new(phase: setting[i], signal: input_signal, instructions: input)
        
        input_signal = amp.output.to_i
      end
      if input_signal > max_thruster_signal
        self.max_thruster_signal = input_signal
      end
    end
    max_thruster_signal
  end

  def all_possible_settings
    [0, 1, 2, 3, 4].permutation.to_a
  end
end

require 'minitest/autorun'
class Program7Test < Minitest::Test
  def test_example_part_one
    assert_equal 43_210, Program7.new('3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0').max_thruster_signal
    assert_equal 54_321, Program7.new('3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0').max_thruster_signal
    assert_equal 65_210, Program7.new('3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0').max_thruster_signal
  end
end

puts "== Part 1, Day 7, 2019"
program = Program7.new(File.read('input.txt'))
puts program.max_thruster_signal