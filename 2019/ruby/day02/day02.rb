class Intcode
  attr_accessor :opcodes, :position
  def initialize(input)
    self.opcodes = input.split(",").map(&:to_i)
    self.position = 0
  end

  def run
    raise unless [1, 2, 99].include?(opcodes[position])
    return opcodes.join(",") if opcodes[position] == 99

    opcodes[overwrite] = result
    self.position = position + 4
    run
  end

  def result
    return values.first + values.last if opcodes[position] == 1
    values.first * values.last
  end

  def values
    [opcodes[opcodes[position + 1]], opcodes[opcodes[position + 2]]]
  end

  def overwrite
    opcodes[position + 3]
  end
end

require 'minitest/autorun'
class IntCodeTest < Minitest::Test
  def test_final_state
    assert_equal '2,0,0,0,99', Intcode.new('1,0,0,0,99').run
    assert_equal '30,1,1,4,2,5,6,0,99', Intcode.new('1,1,1,4,99,5,6,0,99').run
    assert_equal '2,4,4,5,99,9801', Intcode.new('2,4,4,5,99,0').run
  end
end

program = Intcode.new(File.read('input.txt'))
program.opcodes[1] = 12
program.opcodes[2] = 2
puts "== Part 1"
program.run
puts program.opcodes[0]

puts "== Part 2"
expected = 19_690_720
(0..99).each do |noun|
  (0..99).each do |verb|
    program = Intcode.new(File.read('input.txt'))
    program.opcodes[1] = noun
    program.opcodes[2] = verb
    program.run
    output = program.opcodes[0]

    next unless output == expected
    puts 100 * noun + verb
  end
end

