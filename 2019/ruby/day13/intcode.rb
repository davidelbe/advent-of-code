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

  def run(once = false)
    @output_received = false
    while true
      self.current_instruction = Instruction.new(current_value)
      return retval if finished?
      send("opcode_#{current_instruction.opcode.humanize}")
      return retval if halted? && once
    end
  end

  def halted?
    @output_received
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
    self.addresses[overwrite(1)] = inputs.first
    self.position = position + 2
  end

  def opcode_four
    self.retval << values(1)
    self.position = position + 2
    @output_received = true
    return retval
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

class Panel
  attr_accessor :color, :x, :y
  def initialize(x, y, color = 0)
    self.color = color
    self.x = x
    self.y = y
  end
end

class Robot
  attr_accessor :x, :y, :program, :grid, :direction, :current_panel
  attr_reader :current_panel
  def initialize(program)
    self.program = program
    self.grid = []
    self.direction = 'U'
    self.set_panel(0, 0)
  end

  def set_panel(x,y)
    matches = grid.select{ |p| p.x == x && p.y == y }
    if matches.any?
      self.current_panel = matches.first
    else
      self.grid << Panel.new(x, y)
      self.current_panel = grid.last
    end
  end

  def directions
    ['U', 'R', 'D', 'L']
  end

  def move(input)
    steps = input.zero? ? 3 : 1
    
    self.direction = directions[(directions.find_index(direction) + steps) % 4]
    self.set_panel(current_panel.x + x_diff, current_panel.y + y_diff)
  end

  def paint(input)
    current_panel.color = input
  end

  def x_diff
    return -1 if direction == 'L'
    return 1 if direction == 'R'

    0
  end

  def y_diff
    return -1 if direction == 'D'
    return 1 if direction == 'U'

    0
  end
end