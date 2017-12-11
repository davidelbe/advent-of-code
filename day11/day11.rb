# Travel in a Hex grid
class Hex
  attr_reader :max_distance

  def initialize
    @x = 0
    @y = 0
    @max_distance = 0
  end

  def follow(path)
    path.tr("\n", '').split(',').each do |step|
      make_a_step(step)
      save_max_distance
    end
  end

  def make_a_step(step)
    @x += directions[step.to_sym].first
    @y += directions[step.to_sym].last
  end

  def directions
    { n: [0, 1], ne: [1, 0], se: [1, -1], s: [0, -1], sw: [-1, 0], nw: [-1, 1] }
  end

  def distance_from_starting_point
    (@x.abs + @y.abs + (@x + @y).abs) / 2
  end

  def save_max_distance
    d = distance_from_starting_point
    @max_distance = d if d > @max_distance
  end
end
