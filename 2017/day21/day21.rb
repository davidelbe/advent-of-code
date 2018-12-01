# Art class
class Art
  attr_accessor :pattern, :rules

  def initialize(rules = '')
    self.rules = {}
    parse_rules(rules)
    self.pattern = '.#./..#/###'
  end

  def parse_rules(input)
    input.split("\n").each do |r|
      parts = r.split(' => ')
      add_rule(parts[0], parts[1])
      add_rule(rotate90(parts[0]), parts[1])
      add_rule(rotate180(parts[0]), parts[1])
      add_rule(rotate270(parts[0]), parts[1])
      add_rule(mirror(parts[0]), parts[1])
      add_rule(mirror(rotate90(parts[0])), parts[1])
      add_rule(mirror(rotate180(parts[0])), parts[1])
      add_rule(mirror(rotate270(parts[0])), parts[1])
    end
  end

  def add_rule(key, value)
    return if rules.key?(key)
    rules[key] = value
  end

  def rotate90(rule)
    rule
      .split('/')
      .collect(&:chars)
      .transpose
      .collect(&:reverse)
      .collect(&:join)
      .join('/')
  end

  def rotate180(rule)
    rotate90(rotate90(rule))
  end

  def rotate270(rule)
    rotate180(rotate90(rule))
  end

  def mirror(rule)
    rule.split('/').collect(&:reverse).join('/')
  end

  # If the size is evenly divisible by 2, break the pixels up into 2x2 squares,
  # and convert each 2x2 square into a 3x3 square by following the
  # corresponding enhancement rule.
  def enhance!
    squares = (size % 2).zero? ? break_into_2x2_squares : break_into_3x3_squares
    puts squares
    squares.each_with_index do |s, index|
      raise "No matching rule for #{s} in #{rules.keys}" unless rules.key?(s)
      squares[index] = rules[s]
    end
    distribute(squares)
  end

  def distribute(squares)
    squares = squares.collect { |s| s.split('/').collect(&:chars) }
    new_size = Math.sqrt(squares.flatten.join.chars.size).to_i
    puts "New size: #{new_size}"
    raise "Wrong number #{squares.flatten.join.chars.size}" if new_size * new_size != squares.flatten.join.chars.size
    rows = Array.new(new_size, '')
    current_row = 0
    squares.each do |square|
      square.each_with_index do |row, index|
        row.each do |char|
          if rows[current_row + index].chars.size >= new_size
            current_row = rows.index('')
            puts "rows so far: #{rows}"
            puts "Moving to row #{current_row}"
          end
          rows[current_row + index] += char
        end
      end
    end
    self.pattern = rows.join('/')
    puts "NEW PATTERN: #{pattern}"
  end

  def break_into_2x2_squares
    squares = []
    self.pattern = pattern.tr('/', '')
    (size * size / 4).times do |i|
      # Maybe replace size below with 4?
      start = i.odd? ? size * i - 2 : size * i
      squares[i] = [pattern[start],
                    pattern[start + 1], '/',
                    pattern[start + size],
                    pattern[start + size + 1]].join
    end
    squares
  end

  def break_into_3x3_squares
    squares = []
    offset = 0
    self.pattern = pattern.tr('/', '')
    squares = Array.new(size * size / 9, '')
    puts "Breaking into 3x3"
    puts "size: #{size}"
    squares.each_with_index do |square, index|
      puts "square: #{square}, index: #{index+offset}"
      offset += size if squares[index + offset].size == 9
      squares[index + offset] = pattern[index]
    end
    puts "squares: #{squares} for pattern #{pattern}"
    squares
  end

  def on_count
    pattern.count('#')
  end

  def size
    Math.sqrt(pattern_wo_slash.size).to_i
  end

  def pattern_wo_slash
    pattern.tr('/', '')
  end
end
