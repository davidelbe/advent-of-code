# --- Day 8: I Heard You Like Registers ---
class Register
  attr_accessor :input, :registers, :max_value
  def initialize(input)
    self.input = input
    self.registers = {}
    self.max_value = 0
  end

  def follow_instructions
    lines.each do |line|
      next unless passes_condition?(line)
      set_register_value(line.instruction[:key], line.instruction[:change])
    end
  end

  def passes_condition?(line)
    eval(
      line.condition[:comparison].gsub(
        line.condition[:key],
        read_register_value(line.condition[:key]).to_s
      )
    )
  end

  def set_register_value(key, change)
    registers[key] = 0 unless registers.key?(key)
    registers[key] += change
    store_max_value(registers[key])
  end

  def store_max_value(value)
    self.max_value = value if value > max_value
  end

  def read_register_value(key)
    registers.key?(key) ? registers[key] : 0
  end

  def max_register_value
    registers.values.max
  end

  def lines
    input.split("\n").collect { |l| RegisterLine.new(l) }
  end
end

# One line in the register
class RegisterLine
  attr_accessor :line

  def initialize(line)
    self.line = line
  end

  def instruction
    matches = line.match(/(.*) (inc|dec) (.{0,1}\d{1,})/)
    factor = matches[2] == 'inc' ? 1 : -1
    { key: matches[1], change: factor * matches[3].to_i }
  end

  def condition
    matches = line.match(/.* if (\w{1,}) (.*)/).captures
    { key: matches[0], comparison: "#{matches[0]} #{matches[1]}" }
  end
end
