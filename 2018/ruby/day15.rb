class Game
  attr_accessor :grid, :rounds, :continue_game
  def initialize
    self.grid = Grid.new(game: self)
    self.rounds = 0
    self.continue_game = true
  end

  def run
    while continue_game
      grid.output
      grid.warriors.sort_by(&:read_order).each_with_index do |warrior, index|
        next if warrior.dead?

        break end_game if warrior.targets.empty?

        warrior.move
        warrior.attack
      end
      self.rounds += 1
    end
  end

  def end_game
    grid.output
    self.continue_game = false
    print_part_one
  end

  def remaining_hp
    grid.warriors.select(&:alive?).sum(&:hp)
  end

  def print_part_one
    puts "---"
    puts "Part 1:  #{rounds} rounds x #{remaining_hp} HP = #{rounds * remaining_hp}"
  end
end

class Grid
  attr_accessor :game, :pixels, :warriors
  def initialize(game: nil)
    self.pixels = []
    self.warriors = []
    read_input
  end

  def read_input
    filename = ARGV[0] || 'day15.txt'
    File.read(filename).split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        pixels << Pixel.new(grid: self, position: [x, y], wall: char == '#')
        next if ['#', '.'].include?(char)

        warriors << Warrior.new(grid: self, type: char, position: [x, y])
      end
    end
  end

  def output
    print "\e[2J\e[f" # clear screen
    pixels.each do |p|
      print "\n" if p.x.zero?
      print p.sign
    end
  end
end

class Warrior
  attr_accessor :position, :type, :grid, :hp, :ap

  def initialize(grid: nil, position: [], type: 'G')
    self.grid = grid
    self.position = position
    self.type = type
    self.hp = 200
    self.ap = 3
  end

  def read_order
    [position[1], position[0]]
  end

  def targets
    grid.warriors.select do |w|
      w.type != type && w.alive?
    end
  end

  # Return all open squares of enemy warriors
  # (ie no wall, not already taken)
  def target_squares
    targets
      .map(&:pixels_in_range)
      .flatten
      .select(&:open?)
  end

  def print_distance_map
    puts 'Distance map'
    grid.pixels.each do |p|
      print "\n" if p.x.zero?
      print p.distance.nil? ? '?' : p.distance.to_s.chars.last
    end
  end

  require 'pry'
  def move
    #binding.pry if position == [10, 20]
    return if can_attack?
    return if target_squares.empty?

    # Mark every open square in the grid with a distance from this warrior
    calculate_distance(pixel, 0)

    # Find closest target based on distance
    target_square = target_squares
                    .select(&:open?)
                    .reject(&:inaccessible?)
                    .min_by { |t| [t.distance, t.y, t.x] }

    # Mark distance to us from this square
    return if target_square.nil?
    calculate_distance(target_square)

    # Step into the one that takes us closer
    new_pixel = pixels_in_range
                .select(&:open?)
                .reject(&:inaccessible?)
                .min_by { |p| [p.distance, p.y, p.x] }

    self.position = new_pixel.position unless new_pixel.nil?
  end

  def reset_distance(starting_point)
    grid.pixels.map(&:reset_distance)
    starting_point.distance = 0
  end

  def calculate_distance(starting_point, distance = 0)
    reset_distance(starting_point) if distance.zero?
    pixels_to_check = grid.pixels.select { |p| p.distance == distance }
    .map(&:adjacent).flatten.uniq.select{ |p| p.distance.nil? }
    added = 0
    pixels_to_check.compact.each do |px|
      next unless px.distance.nil?
      next if px.wall
      next if px.warrior && px.warrior != self

      px.distance = distance + 1
      added += 1
    end
    calculate_distance(starting_point, distance + 1) if added > 0
  end

  # See if any of our closest pixels contain an enemy
  # that we can attack
  def can_attack?
    pixels_in_range
      .map(&:warrior)
      .compact
      .select { |w| w.alive? && w.type != type }
      .any?
  end

  def attack
    return unless can_attack?

    enemy = pixels_in_range
            .map(&:warrior)
            .compact
            .select { |w| w.alive? && w.type != type }
            .min_by(&:hp)
    enemy.hp -= ap
  end

  def pixel
    grid.pixels.select { |p| p.position == position }.first
  end

  def pixels_in_range
    [pixel.up, pixel.left, pixel.right, pixel.down]
  end

  def alive?
    !dead?
  end

  def dead?
    hp <= 0
  end
end

# Representing a Pixel in the Grid. This can be
# populated by either a wall, be empty, or by a Warrior
class Pixel
  attr_accessor :position, :wall, :grid, :distance

  def initialize(grid: nil, position: [], wall: true)
    self.grid = grid
    self.position = position
    self.wall = wall
    self.distance = nil
  end

  def reset_distance
    self.distance = nil
  end

  def open?
    return false if wall

    warrior.nil?
  end

  def inaccessible?
    distance.nil?
  end

  def warrior
    grid.warriors.select { |w| w.position == position && w.alive? }.first
  end

  def x
    position[0]
  end

  def y
    position[1]
  end

  def adjacent
    @adjacent ||= [up, left, right, down].compact
  end

  def adjacent_open
    adjacent.select(&:open?)
  end

  def left
    @left ||= grid.pixels.select { |p| p.position == [x - 1, y] }.first
  end

  def right
    @right ||= grid.pixels.select { |p| p.position == [x + 1, y] }.first
  end

  def down
    @down ||= grid.pixels.select { |p| p.position == [x, y + 1] }.first
  end

  def up
    @up ||= grid.pixels.select { |p| p.position == [x, y - 1] }.first
  end

  def sign
    return '#' if wall
    return '.' if open?

    warrior.type == 'G' ? 'G'.red : 'E'.yellow
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def yellow
    colorize(33)
  end
end

game = Game.new
game.run

# 259210 - too high!
# 218240 - too high!
# 219024 - wrong
# 191216 - maybe?


# Tests
require 'minitest/autorun'

# Game class test
class GameTest < Minitest::Test
  def test_sum_hp
    # initial state
    g = Game.new
    assert_equal 30 * 200, g.remaining_hp

    # one down
    g.grid.warriors.first.hp = -3
    assert_equal 29 * 200, g.remaining_hp
  end
end

class PixelTest < Minitest::Test
  def test_adjacent
    game = Game.new
    top_left = game.grid.pixels.first

    assert_nil top_left.left
    assert_nil top_left.up
    assert_equal top_left.right.position, [1, 0]
    assert_equal top_left.down.position, [0, 1]
  end

  def test_open
    p = Pixel.new(wall: true)
    assert_equal false, p.open?
  end
end
