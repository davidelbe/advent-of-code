class Scanner
  attr_accessor :input, :severity, :delay

  def initialize(input)
    self.input = input
    self.severity = 0
    self.delay = 0
  end

  def make_trip
    (0..max_number).each do |layer|
      self.severity += layer * depth(layer) if scanner_position(layer).zero?
    end
  end

  def make_trip_fail_fast
    (0..max_number).each do |layer|
     raise "Nooo" if scanner_position(layer).zero?
    end
    true
  rescue
    puts "#{delay} failed"
    false
  end

  def max_number
    input.scan(/(\d{1,}): \d{1,}\z/).flatten.first.to_i
  end

  def scanner_position(layer)
    down = true
    position = 0
    (delay + layer).times do
      down ? position += 1 : position -= 1
      down = false if position == depth(layer) - 1
      down = true if position.zero?
    end
    position
  end

  def depth(layer)
    input.scan(/#{layer}{1}: (\d{1,})/).flatten.first.to_i
  end

  def optimal_delay
    self.delay = 30000
    while !make_trip_fail_fast
      self.delay += 1
      puts "Trying with delay #{delay}"
    end
    delay
  end
end
