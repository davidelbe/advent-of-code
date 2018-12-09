class Marble
  attr_accessor :next_marble, :prev_marble, :number
  def initialize(number)
    self.number = number
  end

  def next
    next_marble
  end

  def prev
    prev_marble
  end

  def delete
    prev_marble.next_marble = next_marble
    next_marble.prev_marble = prev_marble
    self.next_marble = next_marble.next_marble
    self.prev_marble = prev_marble.prev_marble
  end

  def insert_after(another_marble)
    self.prev_marble = another_marble
    self.next_marble = another_marble.next_marble
    prev_marble.next_marble = self
    next_marble.prev_marble = self
  end
end

class Circle
  attr_accessor :players, :marble_max, :placed_marbles, :current_marble, :scores

  def initialize(input)
    self.players = (0...input.first).to_a
    self.marble_max = input.last.to_i
    self.scores = Array.new(players.size)
    first_marble = Marble.new(0)
    first_marble.next_marble = first_marble
    first_marble.prev_marble = first_marble
    self.placed_marbles = [first_marble]
    self.current_marble = first_marble
  end

  def high_score
    scores.max
  end

  def play
    marble_number = 0
    players.cycle do |current_player|
      marble_number += 1
      break if marble_number > marble_max

      # Every player start with 0 score
      scores[current_player] = 0 if scores[current_player].nil?

      marble = Marble.new(marble_number)

      if (marble.number % 23).zero?
        # BONUS TIME!!!

        # First, player get points from picked marble
        scores[current_player] += marble.number

        # Move 7 steps back
        bonus = current_marble.prev.prev.prev.prev.prev.prev.prev

        # Add it to player score
        scores[current_player] += bonus.number

        # Move clockwise, one step
        self.current_marble = bonus.next

        # Remove bonus marble
        bonus.delete
      else
        # Place the marble after the next marble
        marble.insert_after(current_marble.next)

        # Make the newly inserted marble current
        self.current_marble = marble
      end
    end
  end
end
