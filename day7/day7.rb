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
    find_bottom_program
    candidate.split(' ').first
  end

  def total_weight(name)
    weight_of_stack(name) + weight_of_program(name)
  end

  def weight_of_program(name)
    input.scan(/^#{name}\s{1}.(\d{1,})\)/).first.first.to_i
  end

  def children_of_stack(name)
    c = input
        .scan(/^#{name}\s{1}.\d{1,}\).{4}(.{1,})$/)
    c.empty? ? [] : c[0][0].split(', ')
  end

  def weight_of_stack(name)
    children = children_of_stack(name)
    children
      .collect { |c| total_weight(c) }
      .inject(0) { |sum, x| sum + x }
  end

  def balanced?(stacks)
    stack_weights = stacks.collect { |stack| total_weight(stack) }
    stack_weights.uniq.size <= 1
  end

  def imbalance(stacks)
    weights = stacks.collect { |stack| total_weight(stack) }
    pweights = stacks.collect { |name| weight_of_program(name) }
    @fixed_weight = pweights[weights.index(weights.max)]
    @fixed_weight -= (weights.max - weights.min)
    stacks.each do |stack|
      find_unbalanced(children_of_stack(stack))
    end
  end

  def find_unbalanced(stacks)
    @fixed_weight ||= 0
    return imbalance(stacks) unless balanced?(stacks)
    stacks.each do |stack|
      find_unbalanced(children_of_stack(stack))
    end
    @fixed_weight
  end
end
