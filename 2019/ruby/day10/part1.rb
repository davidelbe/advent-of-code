class Asteroid
  attr_accessor :x, :y, :detectable, :distance, :angle
  def initialize(x, y)
    self.x = x
    self.y = y
  end

  def position
    [x, y]
  end

  def quadrant(original)
    if x > original.x
      y > original.y ? 1 : 2
    else
      y > original.y ? 3 : 4
    end
  end

  def angle(original)
    width = x - original.x
    height = y - original.y
    
    Math.atan(height.to_f / width.to_f).to_s + " (Q#{quadrant(original)})"
  end
end

# Parse
def all_asteroids(input)
  asteroids = []
  input.split("\n").each_with_index do |row, y|
    row.chars.each_with_index do |char, x|
      asteroids << Asteroid.new(x, y) if char != '.'
    end
  end
  asteroids
end

def angle_counter(a, asteroid)
  return nil if a.position == asteroid.position

  asteroid.angle(a)
end

def detectable_count(asteroid, others)
  # @debug = asteroid.position == [2, 2]
  others.map { |a|
   angle_counter(a, asteroid)
  }.compact.uniq.count
end

# Loop through them all
input = File.read('input.txt')
puts "== Part 1: Day 10, 2019"
max = all_asteroids(input).map { |asteroid|
  detectable_count(asteroid, all_asteroids(input))
}.max
puts "Answer: #{max}"

all_asteroids(input).each do |asteroid|
   next unless detectable_count(asteroid, all_asteroids(input)) == max
   puts "Position: #{asteroid.position.join(',')}"
   break
end

