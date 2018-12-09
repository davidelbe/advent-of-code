class Circle
  attr_accessor :players, :marbles, :placed_marbles, :current_marble_index, :scores

  def initialize(input)
    self.players = (0...input.first).to_a
    self.scores = Array.new(players.size)
    self.marbles = (1...input.last).to_a
    self.placed_marbles = [0]
    self.current_marble_index = 0
  end

  def high_score
    scores.max
  end

  def play
    players.cycle do |current_player|
      break if marbles.empty?

      # Every player start with 0 score
      scores[current_player] = 0 if scores[current_player].nil?

      # 1. Pick next marble
      marble = marbles.shift

      if marble % 23 == 0
        scores[current_player] += marble
        self.current_marble_index = (current_marble_index - 7) % placed_marbles.size
        scores[current_player] += placed_marbles.delete_at(current_marble_index)
      else
        # Place the marble after the next marble
        self.current_marble_index = (current_marble_index + 2) % placed_marbles.size
        placed_marbles.insert(current_marble_index, marble)

      end
    end
  end
end
