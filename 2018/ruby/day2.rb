# Checksum generator
class Checksum
  attr_accessor :input, :twosomes, :threesomes
  def initialize(input)
    self.input = input
    self.twosomes = 0
    self.threesomes = 0
  end

  # Return max number of occurrances within a string
  def ocurrencies(row, number = 2)
    row
      .chars
      .reduce(Hash.new(0)) { |h, v| h.store(v, h[v] + 1); h }
      .value?(number)
  end

  def checksum
    lines.each do |row|
      self.twosomes += 1 if ocurrencies(row, 2)
      self.threesomes += 1 if ocurrencies(row, 3)
    end

    twosomes * threesomes
  end

  # jiwamotqgcfnudclzbyxkzmrvp
  # jinamojqgsftudclzbyxkhervp
  def line_diff_count(line1, line2)
    diff = 0
    line1.chars.each_with_index do |char, index|
      diff += line2.chars[index] == char ? 0 : 1
    end
    diff
  end

  def common_letters
    lines.each do |line|
      lines.each do |comparison|
        next if line_diff_count(line, comparison) != 1

        return show_common(line, comparison)
      end
    end
  end

  def show_common(line, comparison)
    common = ''
    line.chars.each_with_index do |char, index|
      common << char if comparison[index] == char
    end
    common
  end

  def lines
    @lines ||= input.split("\n")
  end
end
