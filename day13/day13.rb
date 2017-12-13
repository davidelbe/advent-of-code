class Scanner
  attr_accessor :input, :severity, :delay, :keys

  def initialize(input)
    self.input = input
    self.severity = 0
    self.delay = 0
    self.keys = []
  end

  def make_trip
    (0..max_number).each do |layer|
      self.severity += layer * depth(layer) if scanner_position(layer).zero?
    end
  end

  def working_delay?
    (0..max_number).each do |layer|
      return false if scanner_position(layer).zero?
    end
    true
  end

  def max_number
    @max_number ||= input.scan(/(\d{1,}): \d{1,}\z/).flatten.first.to_i
  end

  def scanner_position(layer)
    return -1 if depth(layer) == 0
    (layer + delay) % (2 * (depth(layer) - 1))
  end

  def depth(layer)
    if keys[layer].nil?
      keys[layer] = input.scan(/#{layer}{1}: (\d{1,})/).flatten.first.to_i
    end
    keys[layer]
  end

  def optimal_delay
    self.delay = 0
    self.delay += 1 until working_delay?
    delay
  end
end
