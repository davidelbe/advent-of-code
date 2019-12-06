class Program
  attr_accessor :lines, :input, :com
  def initialize(input)
    self.input = input
    self.com = Orbit.new(name: 'COM', parent: nil, program_input: input)
  end

  def orbits_count
    return 0 unless com.children.any?
    com.children.collect(&:orbits_count).sum    
  end
end

class Orbit
  attr_accessor :program_input, :name, :parent, :children

  def initialize(name: '', parent: nil, program_input: '')
    self.program_input = program_input
    self.name = name
    self.parent = parent
    self.children = []
    find_children
  end

  def orbits_count
    return direct_orbits_count + indirect_orbits_count unless children.any?
    direct_orbits_count + indirect_orbits_count + children.sum(&:orbits_count)
  end

  def find_children
    
    program_input.scan(/#{self.name}\)(\w{1,3})/).each do |child|
      self.children << Orbit.new(name: child.first, parent: self, program_input: program_input)
    end
  end

  def direct_orbits_count
    parent.nil? ? 0 : 1
  end

  def indirect_orbits_count
    return 0 if parent.direct_orbits_count == 0
    parent.direct_orbits_count + parent.indirect_orbits_count
  end
end

require 'minitest/autorun'
class ProgramTest < Minitest::Test
  def test_example_part_one
    input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L"
    assert_equal 42, Program.new(input).orbits_count
  end
end

puts "== Part 1, day 6, 2019"
program = Program.new(File.read('input.txt'))
puts program.orbits_count