# Day 19: Tube
class Tube
  attr_accessor :tube, :position, :direction, :letters, :passed, :skipped

  def initialize(input)
    self.tube = parse input
    self.position = first_position
    self.passed = []
    self.direction = 'down'
    self.letters = ''
    self.skipped = 0
    walk until finished?
  end

  def parse(input)
    a = []
    lines = input.split("\n").reject(&:empty?)
    lines.each_with_index do |line, index|
      a[index] = line.chars.to_a
    end
    a
  end

  def first_position
    [0, tube[0].find_index('|')]
  end

  def opposite_from_direction
    %w[down up].include?(direction) ? '-' : '|'
  end

  def new_direction
    return crossroads_direction if sign == '+'
    return letter_direction if ('A'..'Z').cover?(sign)
    direction
  end

  def sign_in_direction(direction)
    sign(coordinates_for_direction(direction))
  end

  def coordinates_for_direction(direction)
    position.zip(coordinate_multiplier(direction)).map { |x, y| x + y }
  end

  def crossroads_direction(tries = 0)
    return 'left' if tries > 3
    a = %w[left right down up]
    suggestion = a[tries]
    if already_passed?(coordinates_for_direction(suggestion))
      return crossroads_direction(tries + 1)
    end
    return crossroads_direction(tries + 1) if
      finished?(sign_in_direction(suggestion))
    suggestion
  end

  def other_direction
    %w[left right].include?(direction) ? 'up' : 'right'
  end

  # We have reached a letter. It can behave as a crossroad,
  # but also just continue in the same direction as before
  def letter_direction
    just_walk_forward = sign_in_direction(direction)
    return direction unless finished?(just_walk_forward)
    crossroads_direction
  end

  # are we on a +, - or |
  def sign(p = [])
    p = position if p.empty?
    tube[p.first][p.last]
  rescue NoMethodError
    ' '
  end

  def next_field
    position.zip(coordinate_multiplier).map { |x, y| x + y }
  end

  def coordinate_multiplier(d = '')
    case d.empty? ? direction : d
    when 'down'
      [1, 0]
    when 'up'
      [-1, 0]
    when 'right'
      [0, 1]
    when 'left'
      [0, -1]
    end
  end

  def steps
    passed.count + skipped
  end

  def walk
    store_letter
    self.position = next_field
    while sign == opposite_from_direction
      self.skipped += 1
      self.position = next_field
    end
    passed << position
    self.direction = new_direction
  end

  def store_letter
    letters << sign unless ['+', '-', ' ', '|'].include?(sign)
  end

  def already_passed?(pos)
    passed.include? pos
  end

  def finished?(s = '')
    s = sign if s.empty?
    s.empty? || s.nil? || s == ' '
  end
end
