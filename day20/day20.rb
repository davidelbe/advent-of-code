# Day 20 - Particle Swarm
class Swarm
  attr_accessor :particles

  def initialize(input, remove = false)
    self.particles = parse_input(input)
    @remove = remove
  end

  def parse_input(input)
    id = 0
    input
      .split("\n")
      .collect do |l|
        digits = l.scan(/(-{0,1}\d{1,})/).flatten.collect(&:to_i)
        particle = Particle.new(id, digits[0..2], digits[3..5], digits[6..8])
        id += 1
        particle
      end
  end

  def closest
    particles
      .sort_by(&:distance_from_origo)
      .first
      .id
  end

  def move
    particles.each(&:move)
    collision_detection if @remove
  end

  def collision_detection
    particles.each do |particle|
      matching = with_matching_position(particle)
      next unless matching.any?
      matching.push(particle).collect { |m| particles.delete(m) }
    end
  end

  def with_matching_position(particle)
    particles.select do |p|
      p.position == particle.position && p.id != particle.id
    end
  end
end

# A particle is part of a swarm
class Particle
  attr_accessor :id, :position, :velocity, :acceleration

  def initialize(id, position, velocity, acceleration)
    self.id = id
    self.position = position
    self.velocity = velocity
    self.acceleration = acceleration
  end

  def distance_from_origo
    position[0].abs + position[1].abs + position[2].abs
  end

  def move
    self.velocity = velocity.zip(acceleration).collect { |i| i[0] + i[1] }
    self.position = position.zip(velocity).collect { |i| i[0] + i[1] }
  end
end
