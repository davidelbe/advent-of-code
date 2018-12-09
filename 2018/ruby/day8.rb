input = File.read('day8.txt')

class Calculator
  attr_accessor :numbers
  def initialize(input)
    self.numbers = input.split(' ').map(&:to_i)
  end

  def summarizer(node_numbers, &instructions)
    child_count = node_numbers.shift
    meta_count = node_numbers.shift
    yield(
      Array.new(child_count).map { summarizer(node_numbers, &instructions) },
      node_numbers.shift(meta_count)
    )
  end

  def meta_sum
    summarizer(numbers.dup) { |child, meta| child.sum + meta.sum }
  end

  def value
    summarizer(numbers.dup) do |children, metadata|
      if children.empty?
        metadata.sum
      else
        metadata.sum { |number| children[number - 1] || 0 }
      end
    end
  end
end

c = Calculator.new(File.read('day8.txt'))
puts c.meta_sum

c = Calculator.new(File.read('day8.txt'))
puts c.value
