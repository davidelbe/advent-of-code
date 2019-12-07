# frozen_string_literal: true

class Intcode
  attr_accessor :addresses, :position, :current_instruction, :inputs, :retval
  def initialize(inputs = [], instructions)
    self.addresses = instructions.split(',').map(&:to_i)
    self.retval = nil
    self.position = 0
    self.inputs = inputs
  end

  def run
    self.current_instruction = Instruction.new(current_value)

    return retval if finished?

    opcode_one
    opcode_two
    opcode_three
    return retval if opcode_four
    opcode_five
    opcode_six
    opcode_seven
    opcode_eight

    run
  end

  def opcode_one
    return unless current_instruction.opcode == 1

    addresses[overwrite] = result
    self.position = position + 4
  end

  def opcode_two
    return unless current_instruction.opcode == 2

    addresses[overwrite] = result
    self.position = position + 4
  end

  def opcode_three
    return unless current_instruction.opcode == 3

    addresses[addresses[position + 1]] = inputs.first.to_i
    self.inputs = inputs.drop(1)
    self.position = position + 2
  end

  def opcode_four
    return false unless current_instruction.opcode == 4

    self.retval = addresses[addresses[position + 1]]
    self.position = position + 2
    retval
  end

  def opcode_five
    return unless current_instruction.opcode == 5

    self.position = if values.first != 0
                      values.last
                    else
                      position + 3
                    end
  end

  def opcode_six
    return unless current_instruction.opcode == 6

    self.position = if values.first == 0
                      values.last
                    else
                      position + 3
                    end
  end

  def opcode_seven
    return unless current_instruction.opcode == 7

    val = values.first < values.last ? 1 : 0
    addresses[overwrite] = val
    self.position = position + 4
  end

  def opcode_eight
    return unless current_instruction.opcode == 8

    val = values.first == values.last ? 1 : 0
    addresses[overwrite] = val
    self.position = position + 4
  end

  def finished?
    return false if current_instruction.nil?

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
  attr_accessor :input, :output, :program, :next

  def initialize(signal: 0, instructions: '')
    self.program = Intcode.new([signal], instructions)
  end

  def output
    program.run
  end

  def add_input(input)
    program.inputs << input.to_i
  end

  def finished?
    program.finished?
  end
end

class Program7
  attr_accessor :max_thruster_signal, :amplifiers, :settings, :input, :amps
  def initialize(input)
    self.amps = []
    self.input = input
    self.max_thruster_signal = 0
    all_possible_settings.each do |setting|
      self.settings = setting
      setup_amps
      current_amp = amps[0]
      until current_amp.finished?
        current_amp.next.add_input(current_amp.output)
        current_amp = current_amp.next
      end

      if amps[4].output > max_thruster_signal
        self.max_thruster_signal = amps[4].output
      end
    end
    max_thruster_signal
  end

  def setup_amps
    amps[0] = Amplifier.new(signal: settings[0], instructions: input)
    #amps[0].add_input(settings[0])
    amps[1] = Amplifier.new(signal: settings[1], instructions: input)
    amps[2] = Amplifier.new(signal: settings[2], instructions: input)
    amps[3] = Amplifier.new(signal: settings[3], instructions: input)
    amps[4] = Amplifier.new(signal: settings[4], instructions: input)

    amps[0].next = amps[1]
    amps[1].next = amps[2]
    amps[2].next = amps[3]
    amps[3].next = amps[4]
    amps[4].next = amps[0]
  end

  def all_possible_settings
    [5, 6, 7, 8, 9].permutation.to_a
  end
end

require 'minitest/autorun'
class Program7Test < Minitest::Test
  def test_example_part_one
    assert_equal 139_629_729, Program7.new('3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5').max_thruster_signal
    assert_equal 18_216, Program7.new('3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10').max_thruster_signal
  end
end

puts '== Part 2, Day 7, 2019'
program = Program7.new(File.read('input.txt'))
puts "Answer: #{program.max_thruster_signal}"
