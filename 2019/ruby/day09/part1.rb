require 'byebug'

require 'humanize'

class Intcode
  attr_accessor :addresses, :position, :current_instruction, :inputs, :retval, :offset
  def initialize(inputs = [], instructions)
    self.addresses = instructions.split(',').map(&:to_i)
    self.retval = []
    self.position = 0
    self.offset = 0
    self.inputs = inputs
  end

  def run
    while true
      self.current_instruction = Instruction.new(current_value)
      return retval if finished?
      send("opcode_#{current_instruction.opcode.humanize}")
    end
  end

  def opcode_one
    self.addresses[overwrite(3)] = values(1) + values(2)
    self.position = position + 4
  end

  def opcode_two
    self.addresses[overwrite(3)] = values(1) * values(2)
    self.position = position + 4
  end

  def overwrite(parameter_number)
    case current_instruction.parameter_modes[parameter_number - 1].to_i
    when 0
      addresses[position + parameter_number].to_i
    when 1
      position + parameter_number
    when 2
      addresses[position + parameter_number].to_i + offset
    end
  end

  def opcode_three
    self.addresses[overwrite(1)] = inputs.first.to_i
    self.inputs = inputs.drop(1)
    self.position = position + 2
  end

  def opcode_four
    self.retval << values(1)
    self.position = position + 2
    retval
  end

  def opcode_five
    self.position = values(1) != 0 ? values(2) : position + 3
  end

  def opcode_six
    self.position = values(1) == 0 ? values(2) : position + 3
  end

  def opcode_seven
    addresses[overwrite(3)] = values(1) < values(2) ? 1 : 0
    self.position = position + 4
  end

  def opcode_eight
    addresses[overwrite(3)] = values(1) == values(2) ? 1 : 0
    self.position = position + 4
  end

  def opcode_nine
    self.offset = offset + values(1)
    self.position = position + 2
  end

  def finished?
    return false if current_instruction.nil?

    current_instruction.opcode == 99
  end

  def current_value
    addresses[position].to_i
  end

  def values(steps)
    addresses[overwrite(steps)] || 0
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

program = Intcode.new([1], File.read('input.txt'))
puts "Running"
puts "Answer part 1: #{program.run.first}"

program = Intcode.new([2], File.read('input.txt'))
puts "Running"
puts "Answer part 2: #{program.run.first}"