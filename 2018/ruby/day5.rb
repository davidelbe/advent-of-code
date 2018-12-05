# Polymer class
class Polymer
  attr_accessor :result
  def initialize(input)
    self.result = input.chars
  end

  def react
    changes = 0
    result.each_with_index do |char, index|
      next unless char.swapcase == result[index + 1]

      result.slice!(index, 2)
      changes += 1
    end
    react if changes > 0
    result.size
  end
end

# Compare unit removals
class PolymerUnitRemover
  attr_accessor :lowest_count, :input
  def initialize(input)
    self.lowest_count = 999_999_999
    self.input = input
    compare
  end

  def compare
    input.downcase.chars.uniq.each do |char|
      count = Polymer.new(test_input(char)).react
      self.lowest_count = count if count < lowest_count
    end
    lowest_count
  end

  def test_input(char)
    input.chars.reject { |c| [char, char.upcase].include?(c) }.join
  end
end
