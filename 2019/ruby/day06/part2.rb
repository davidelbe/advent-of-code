class Program
  attr_accessor :lines, :input, :com
  def initialize(input)
    self.input = input
  end

  def shortest_way(a, b)
    a = Orbit.new(name: a, program_input: input).all_parents.flatten
    b = Orbit.new(name: b, program_input: input).all_parents.flatten

    ((a + b) - (a & b)).size
  end
end

class Orbit
  attr_accessor :program_input, :name, :parent

  def initialize(name: '', program_input: '')
    self.program_input = program_input
    self.name = name
    find_parents
  end

  def all_parents
    return [parent.name] if parent.parent.nil?
    [parent.name, parent.all_parents]
  end

  def find_parents    
    program_input.scan(/(\w{1,3})\)#{self.name}/).each do |p|
      self.parent = Orbit.new(name: p.first, program_input: program_input)
    end
  end
end

require 'minitest/autorun'
class ProgramTest < Minitest::Test
  def test_example_part_two
    input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN"
    assert_equal 4, Program.new(input).shortest_way('YOU', 'SAN')
  end
end

puts "== Part 2, day 6, 2019"
program = Program.new(File.read('input.txt'))
puts program.shortest_way('YOU', 'SAN')