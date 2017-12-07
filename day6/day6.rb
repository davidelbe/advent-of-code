# Day 6: Memory Reallocation
class Memory
  attr_accessor :steps, :checksums, :banks
  def initialize(input)
    self.banks = input
    self.steps = 0
    self.checksums = []
  end

  def reallocate
    reallocate_once until known_position?
  end

  def reallocate_cycle
    reallocate
    self.checksums = []
    self.steps = 0
    reallocate
  end

  def reallocate_once
    self.steps += 1
    max = banks.max
    index = banks.index(max)
    banks[index] = 0
    max.times do
      index = (index + 1) % banks.size
      banks[index] += 1
    end
  end

  def known_position?
    checksums << banks.to_s
    checksums.uniq != checksums
  end
end
