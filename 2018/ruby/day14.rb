require 'minitest/autorun'

class Recipe
  attr_accessor :next, :score
  def initialize(score)
    self.score = score
  end
end

class Elf
  attr_accessor :current_recipe
  def initialize(recipe)
    self.current_recipe = recipe
  end

  def current_score
    current_recipe.score.to_i
  end

  def steps
    current_recipe.score + 1
  end

  def move
    self.current_recipe = current_recipe.next
  end
end

class ScoreBoard
  attr_accessor :recipes, :elves, :number, :sequence, :last_x_added
  def initialize(number = 0)
    self.number = number
    self.recipes = []
    add_recipe(3)
    add_recipe(7)
    self.elves = [Elf.new(recipes.first), Elf.new(recipes.last)]
    (number - 2).times do
      run
    end
  end

  def run
    score_sum.to_s.chars.each do |c|
      add_recipe(c.to_i)
    end
    move_elves
  end

  def find_sequence(sequence)
    self.sequence = sequence
    self.last_x_added = '-' * sequence.size
    n = 0
    loop do
      begin
        run
      rescue StandardError => e
        n = recipes.size - sequence.size
        break
      end
    end
    n
  end

  def print
    current = recipes[number - 1]
    10.times do
      run
    end
    output = ''
    10.times do
      output += current.next.score.to_s
      current = current.next
    end
    output
  end

  def sequence_matched?
    return false if sequence.nil?

    self.last_x_added += recipes.last.score.to_s
    self.last_x_added[0] = ''
    return false if sequence.chars[-1] != last_x_added[-1]
    return false if sequence.chars[-2] != last_x_added[-2]
    return false if last_x_added != sequence

    sequence == recipes.last(sequence.size).map(&:score).join
  end

  def score_sum
    elves.map(&:current_score).sum
  end

  def move_elves
    elves.each do |elf|
      elf.steps.times do
        elf.move
      end
    end
  end

  def add_recipe(score)
    recipe = Recipe.new(score)
    recipes.last.next = recipe if recipes.any?
    recipes << recipe
    recipes.last.next = recipes.first
    return unless sequence_matched?

    raise 'Number reached'
  end
end

class ScoreBoardTest < Minitest::Test
  def test_example_part_one
    s = ScoreBoard.new(5)
    assert_equal '0124515891', s.print

    s = ScoreBoard.new(9)
    assert_equal '5158916779', s.print
  end

  def test_example_part_two
    s = ScoreBoard.new
    assert_equal 9, s.find_sequence('51589')

    s = ScoreBoard.new
    assert_equal 2018, s.find_sequence('59414')

    s = ScoreBoard.new
    assert_equal 18, s.find_sequence('92510')
  end
end

# Usage: day14.rb 12345
input = ARGV[0] || '157901'
score = ScoreBoard.new(input.to_i)
part1 = score.print
puts "Part 1: #{part1}"
s = ScoreBoard.new
part2 = s.find_sequence(input.to_s)
puts "Part 2: #{part2}"
# 20317612
