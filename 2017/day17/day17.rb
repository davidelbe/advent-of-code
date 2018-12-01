class Spinlock
  attr_accessor :steps, :numbers, :position

  def initialize(steps)
    self.steps = steps
    self.numbers = [0]
    self.position = 0
  end

  def spin!(number)
    number.times do
      spin_once!
    end
  end

  # Zero is always at the beginning, so don't bother populating
  # the array at all
  def spin_fast(number)
    position = 0
    after_zero = 0
    (1..number + 1).each do |i|
      position = (position + steps) % i
      after_zero = i if position.zero?
      position += 1
    end
    after_zero
  end

  def spin_once!
    self.position = next_position(steps)
    numbers.insert(position + 1, next_number)
    self.position = next_position(1)
  end

  def next_number
    numbers.max + 1
  end

  def next_position(number_of_steps)
    (position + number_of_steps) % numbers.size
  end

  def output
    numbers.at(next_position(1))
  end
end
