# calculate frequency change
class FrequencyChange
  attr_accessor :changes, :frequencies, :current_frequency

  def initialize()
    self.frequencies = [0]
  end

  # Sum of all inputs
  def sum(input)
    self.changes = input.split(' ').map(&:to_i)
    changes.sum
  end

  # Find the first repeating frequency
  def repeat(input)
    self.frequencies = [0]
    self.changes = input.split(' ').map(&:to_i)
    new_frequency = 0
    index = 0
    loop do
      new_frequency += changes[index]
      puts "#{frequencies.size} : #{new_frequency}"
      index = index == changes.size - 1 ? 0 : index + 1
      break if frequencies.include?(new_frequency)

      frequencies << new_frequency
    end
    new_frequency
  end
end
