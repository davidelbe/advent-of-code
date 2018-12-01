require_relative '../day10/day10.rb'
require_relative '../day12/day12.rb'

# Defrag class
class Defrag
  attr_accessor :input, :output

  def initialize(input)
    self.input = input
    self.output = []
    process_data
  end

  def knot
    Knot.new((0..255).to_a)
  end

  def bits_from_string(string)
    k = knot
    k.fold_string(string)
    k.dense_hash.chars.collect { |c| bits_from_char(c) }.join
  end

  def bits_from_char(char)
    char.hex.to_s(2).rjust(4, '0')
  end

  def used_bits
    output.join.count('1')
  end

  def process_data
    128.times do |i|
      output << bits_from_string("#{input}-#{i}")
    end
  end

  def all_bits
    output.join.size
  end

  def connections
    out = ''
    all_bits.times do |position|
      line = (position / 128).floor
      char = (position % 128)
      next if empty?(line, char)
      out << connection_string(position, directly_connected(char, line))
    end
    out
  end

  def connection_string(position, connected)
    return "#{position} <-> #{position}\n" if connected.empty?
    "#{position} <-> #{connected.join(', ')}\n"
  end

  # I decided to reuse the code from day 12 to find connections
  # between elements.
  def groups
    p = Plumber.new(connections)
    p.groups
  end

  def empty?(line, char)
    output[line].chars[char] == '0'
  end

  def directly_connected(char, line)
    neighbor_coordinates(char, line)
      .collect { |c| position_value(c[1], c[0]) }
      .compact
  end

  def line_length
    @ll ||= output.first.length
  end

  def position_value(line, char)
    return nil if char < 0
    return nil if char >= line_length
    return nil if output[line].nil?
    return nil if output[line].chars[char] == '0'
    (128 * line) + char
  end

  def neighbor_coordinates(x, y)
    [[x - 1, y], [x + 1, y], [x, y + 1], [x, y - 1]]
  end
end
