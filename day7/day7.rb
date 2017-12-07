# --- Day 7: Recursive Circus ---
class Circus
  attr_accessor :input, :candidate, :held_by_others

  def initialize(input)
    self.input = input
    self.candidate = ''
    build_held_by_others
  end

  def find_bottom_program
    input.split("\n").each do |line|
      next if line.empty?
      next if line.count(',').zero?
      next if held_by_others.include?(line.split(' ').first)
      self.candidate = line
    end
  end

  def build_held_by_others
    self.held_by_others = []
    input.split("\n").each do |line|
      parts = line.split('->')
      next if parts.size == 1
      @held_by_others << parts[-1].strip.split(',').collect(&:strip)
    end
    held_by_others.flatten!
  end

  def bottom_program_name
    candidate.split(' ').first
  end
end
