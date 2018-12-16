class Game
  attr_accessor :grid, :rounds, :continue_game, :raise_on_death, :attack_power
  def initialize(raise_on_death = false, attack_power = 3)
    self.rounds = 0
    self.continue_game = true
    self.raise_on_death = raise_on_death
    self.attack_power = attack_power
    self.grid = Grid.new(game: self)
  end

  def run
    while continue_game
      grid.output
      grid.warriors.sort_by(&:read_order).each do |warrior|
        raise if unwanted_outcome?(warrior)
        next if warrior.dead?

        break end_game if warrior.targets.empty?

        warrior.move
        warrior.attack
      end
      self.rounds += 1
    end
  end

  # For some reason, they did not want the elves to die
  def unwanted_outcome?(warrior)
    raise_on_death && warrior.dead? && warrior.type == 'E'
  end

  def end_game
    grid.output
    self.continue_game = false
    print_result
  end

  def remaining_hp
    grid.warriors.select(&:alive?).sum(&:hp)
  end

  def print_result
    puts '---'
    puts "Answer:  #{rounds} rounds x #{remaining_hp} HP = #{rounds * remaining_hp}"
  end
end

class Grid
  attr_accessor :game, :pixels, :warriors
  def initialize(game: nil)
    self.pixels = []
    self.warriors = []
    self.game = game
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
    print "\n"
  end
end

# A fighting unit, either Goblin or Elf
class Warrior
  attr_accessor :position, :type, :grid, :hp, :ap

  def initialize(grid: nil, position: [], type: 'G')
    self.grid = grid
    self.position = position
    self.type = type
    self.hp = 200
    self.ap = (type == 'G' ? 3 : grid.game.attack_power || 3)
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
      .uniq
      .select(&:open?)
  end

  def pick_closest_target_square
    target_squares
      .select(&:open?)
      .reject(&:inaccessible?)
      .min_by { |t| [t.distance, t.y, t.x] }
  end

  def move
    return if can_attack? || target_squares.empty?

    # Mark every open square in the grid with a distance from this warrior
    calculate_distance(pixel, 0)

    # Find closest target based on distance
    target_square = pick_closest_target_square
    return if target_square.nil?

    # Mark distance to us from this square
    calculate_distance(target_square)

    # Step into the one that takes us closer
    new_pixel = pick_first_pixel_that_takes_us_closer

    self.position = new_pixel.position unless new_pixel.nil?
  end

  def pick_first_pixel_that_takes_us_closer
    pixels_in_range
      .select(&:open?)
      .reject(&:inaccessible?)
      .min_by { |p| [p.distance, p.y, p.x] }
  end

  def reset_distance(starting_point)
    grid.pixels.map(&:reset_distance)
    starting_point.distance = 0
  end

  def calculate_distance(starting_point, distance = 0)
    reset_distance(starting_point) if distance.zero?
    pixels_to_check = all_pixels_just_outside(distance)
    added = false
    pixels_to_check.each do |px|
      next if px.warrior && px.warrior != self

      px.distance = distance + 1
      added = true
    end
    calculate_distance(starting_point, distance + 1) if added
  end

  # Return all pixels around a previously calculated
  # distance, so we can tag them with distance + 1
  def all_pixels_just_outside(distance)
    grid
      .pixels
      .select { |p| p.distance == distance }
      .map(&:adjacent)
      .flatten
      .uniq
      .select { |p| p.distance.nil? && !p.wall }
      .compact
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
    pixel.adjacent
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
    return ' ' if open?

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

# Part 1
game = Game.new
game.run
sleep 5

# Part 2
@attack_power = 4
begin
  game = Game.new(true, @attack_power)
  game.attack_power = @attack_power
  game.run
rescue StandardError
  puts 'One of the elves died!'
  puts "Attacking power was #{@attack_power}"
  @attack_power += 1
  sleep 2
  retry
end

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
