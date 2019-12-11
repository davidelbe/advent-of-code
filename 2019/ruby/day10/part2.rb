

require 'byebug' 

class Asteroid
  attr_accessor :x, :y, :detectable, :distance, :angle
  def initialize(x, y)
    self.x = x
    self.y = y
  end

  def position
    [x, y]
  end

  def distance(original)
    width = x - original.x
    height = y - original.y
    width.abs + height.abs
  end

  def quadrant(original)
    if x >= original.x
      y <= original.y ? 1 : 2
    else
      y >= original.y ? 3 : 4
    end
  end

  def angle(original)
    width = x - original.x
    height = y - original.y
    
    [
      quadrant(original),
      Math.atan(height.to_f / width.to_f).to_s
    ].join("-")
  end
end
original = Asteroid.new(20, 20)


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

def vaporize(asteroid)
  @all.each do |a|
    next unless a.position == asteroid.position
    return @all.delete(a)
  end
end

# Loop through them all
input = File.read('input.txt')
@all = all_asteroids(input).compact
all_angles = @all.map{|a| a.angle(original) }.compact.uniq.sort
@asteroid_list = {}

# Fill the list
@all.each do |asteroid|
  next if original.position == asteroid.position
  @asteroid_list[asteroid.angle(original)] = [] if @asteroid_list[asteroid.angle(original)].nil?
  @asteroid_list[asteroid.angle(original)] << asteroid
  @asteroid_list[asteroid.angle(original)].sort_by { |a| a.distance(original) }
end


@current_angle_index = 0
def next_angle(current_angle_index)
  all_angles[current_angle_index + 1] == nil ? all_angles[0] : all_angles[current_angle_index + 1]
end

def next_angle!
  @current_angle_index += 1
  @current_angle_index = 0 if @current_angle_index > @all_angles.size - 1
end

def current_angle
  @all_angles[@current_angle_index]
end

@all_angles = all_angles
vaporized = 0
puts "== Part 2: Day 10, 2019"

vaporize(original)
# All angles, grouped by quadrant and distance
while(vaporized < 200)
  if !@asteroid_list[current_angle].nil?
    vaporized += 1
    a = @asteroid_list[current_angle].pop
    puts "Answer: #{a.x * 100 + a.y}" if vaporized == 200
  end
  next_angle!
end

