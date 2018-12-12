require 'minitest/autorun'

# Farm
class Farm
  attr_accessor :initial_state, :rules, :starting_index, :current_state, :generation

  def initialize(input)
    self.starting_index = 0
    self.generation = 0
    self.initial_state = input.scan(/initial state: (.+)/).first.first
    self.current_state = fix_state(initial_state)
    self.rules = input.scan(/(.+) => (.)/)
  end

  def fix_state(state)
    if state[0..3] != '....'
      state = "....#{state}"
      self.starting_index += 4
    end
    state = "#{state}...." if state[-4, 4] != '....'
    state
  end

  def next_generation
    puts "#{generation}: #{sum} | #{current_state}"
    new_state = ''
    current_state.chars.each_with_index do |pot, index|
      if index < 2 || index > current_state.size - 2
        new_state << pot
        next
      end

      np = '.'
      rules.each do |rule|
        if rule[0] == [current_state.chars[index - 2], current_state.chars[index - 1], pot, current_state.chars[index + 1], current_state.chars[index + 2]].join
          np = rule[1]
          break
        end
      end
      new_state << np
    end
    self.generation += 1
    self.current_state = fix_state(new_state)
  end

  def slope
    return @slope if @slope

    # Prepare
    110.times do
      next_generation
    end
    x1 = generation
    y1 = sum
    next_generation
    x2 = generation
    y2 = sum

    # Calculate slope
    @slope = (y2 - y1) / (x2 - x1)
    @offset = y1 - (@slope * x1)
    @slope
  end

  attr_reader :offset

  def sum
    s = 0
    current_state.chars.each_with_index do |pot, index|
      next if pot == '.'

      s += (index - starting_index)
    end
    s
  end

  def sum_after(iterations)
    slope * iterations + offset
  end
end

class FarmTest < Minitest::Test
  def test_initial_state
    farm = Farm.new(File.read('day12_example.txt'))

    assert_equal farm.initial_state, '#..#.#..##......###...###'
  end

  def test_one_generation
    farm = Farm.new(File.read('day12_example.txt'))

    farm.next_generation

    assert farm.current_state.include?('#...#....#.....#..#..#..#')
  end

  def test_two_generations
    farm = Farm.new(File.read('day12_example.txt'))

    farm.next_generation
    farm.next_generation

    assert farm.current_state.include?('##..##...##....#..#..#..##')
  end

  def test_twenty_generations
    farm = Farm.new(File.read('day12_example.txt'))

    20.times do
      farm.next_generation
    end

    assert farm.current_state.include?('.#....##....#####...#######....#.#..##.')
    assert_equal 325, farm.sum
  end

  def test_part_one
    farm = Farm.new(File.read('day12.txt'))

    20.times do
      farm.next_generation
    end

    assert_equal 2_140, farm.sum
  end

  # y = 38.0 x + 384.0
  # looking at the output after 100 looks like a straight line
  def test_part_two
    farm = Farm.new(File.read('day12.txt'))
    assert_equal 38, farm.slope
    assert_equal 384, farm.offset
    assert_equal 1_900_000_000_384, farm.sum_after(50_000_000_000)
  end
end
