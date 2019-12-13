class Moon
  attr_accessor :position, :velocity, :repeat, :starting
  def initialize(x, y, z)
    self.position = [x, y, z]
    self.starting = [x, y, z]
    self.velocity = [0, 0, 0]
  end

  def back_to_origin?(axis)
    position[axis] == starting[axis]
  end

  def kinetic
    velocity.map{ |p| p.abs }.sum
  end

  def potential
    position.map{ |p| p.abs }.sum
  end

  def total
    kinetic * potential
  end
end

def add_gravity
  variants = [
    [0, 1], [0, 2], [0, 3], 
    [1, 2], [2, 3], [1, 3]
  ]

  3.times do |axis|
    variants.each do |variant|
      if @moons[variant.first].position[axis] > @moons[variant.last].position[axis]
        @moons[variant.first].velocity[axis] -= 1
        @moons[variant.last].velocity[axis] += 1
      elsif @moons[variant.first].position[axis] < @moons[variant.last].position[axis]
        @moons[variant.first].velocity[axis] += 1
        @moons[variant.last].velocity[axis] -= 1
      end
    end
  end
end

def add_velocity
  @moons.each do |moon|
    3.times do |axis|
      moon.position[axis] += moon.velocity[axis]
    end
  end
end

@moons = []
input = File.read('input.txt')
input.split("\n").each do |line|
  x, y, z = line.scan(/x=(\-{0,1}\d{1,}), y=(\-{0,1}\d{1,}), z=(\-{0,1}\d{1,})/)[0]
  @moons << Moon.new(x.to_i, y.to_i, z.to_i)
end

back = [nil, nil, nil]

1_000_000.times do |i|
  add_gravity
  add_velocity

  3.times do |axis|
    if @moons.all? { |m| m.back_to_origin?(axis) }
      # offset = 2 (zero-based + next one velocity is zero)
      back[axis] = i + 2 if back[axis].nil? && i > 0   
    end
  end

  if back.compact.size == 3
    @back = back
    puts "=== Part 2:"
    puts back.reduce(1, :lcm)
    break 
  end
end

puts "== Part 1:"
puts @moons.map { |p| p.total }.sum
