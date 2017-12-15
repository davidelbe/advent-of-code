# Match lower bits of numbers with each other
class Judge
  attr_accessor :rounds, :matches

  def initialize(a, b)
    self.rounds = 5
    self.matches = 0
    @a = a
    @b = b
    @c = { a: [], b: [] }
  end

  def candidates
    @c
  end

  def lower_bits_of(int)
    return 0 if int.nil?
    int.to_s(2).rjust(32, '0')[-16, 16]
  end

  def eql_lower_bits?(a, b)
    lower_bits_of(a) == lower_bits_of(b)
  end

  # Part 1
  def calculate
    rounds.times do
      @a = (@a * 16_807) % 2_147_483_647
      @b = (@b * 48_271) % 2_147_483_647
      self.matches += 1 if eql_lower_bits?(@a, @b)
    end
  end

  def pairs_count
    [candidates[:a].count, candidates[:b].count].min
  end

  # Part 2
  def picky_calculate
    while pairs_count < rounds
      increase_a
      increase_b
    end
    @c[:a].each_with_index do |a, index|
      self.matches += 1 if eql_lower_bits?(a, @c[:b][index])
    end
  end

  def increase_a
    @a = (@a * 16_807) % 2_147_483_647
    send_to_judge(:a, @a) if (@a % 4).zero?
  end

  def increase_b
    @b = (@b * 48_271) % 2_147_483_647
    send_to_judge(:b, @b) if (@b % 8).zero?
  end

  def send_to_judge(a_or_b, value)
    @c[a_or_b].push(value)
  end
end
