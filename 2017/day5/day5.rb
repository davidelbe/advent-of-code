# Day 5: A Maze of Twisty Trampolines, All Alike
class Maze
  attr_reader :steps

  def initialize(input)
    @maze = input.compact.collect(&:to_i)
    @position = 0
    @steps = 0
  end

  def step_outside(part = 1)
    @part = part
    take_a_step until outside?
    @steps
  end

  def take_a_step
    move_to_new_position
    increment_old_position
  end

  def move_to_new_position
    @old_position = @position
    @position = @old_position + @maze[@old_position]
    @steps += 1
  end

  def increment_old_position
    if @part == 2 && @maze[@old_position] >= 3
      @maze[@old_position] -= 1
    else
      @maze[@old_position] += 1
    end
  end

  def outside?
    @maze[@position].nil?
  end
end
