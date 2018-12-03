# Elf-made claim
class Claim
  attr_accessor :id, :left, :top, :width, :height

  # string: #123 @ 3,2: 5x4
  def initialize(string)
    matches = string.scan(/(\d{1,})/)
    self.id = value_of(matches, 0)
    self.left = value_of(matches, 1)
    self.top = value_of(matches, 2)
    self.width = value_of(matches, 3)
    self.height = value_of(matches, 4)
  end

  def min_rectangle_width
    left + width
  end

  def min_rectangle_height
    top + height
  end

  def first_row
    top
  end

  def last_row
    top + height - 1
  end

  def first_col
    left
  end

  def last_col
    left + width - 1
  end

  def positions(max_width: 0)
    pos = []
    (first_row..last_row).each do |row|
      (first_col..last_col).each do |col|
        pos << (row * max_width) + col
      end
    end
    pos
  end

  private

  def value_of(matches, position)
    matches[position].first.to_i
  end
end

# The large Rectangle
class Rectangle
  attr_accessor :claims, :rows, :cols

  def initialize(array_of_claims)
    self.claims = []
    self.rows = 0
    self.cols = 0
    add_all_claims(array_of_claims)
    position_claims
  end

  def to_s
    puts squares.scan(/.{1, #{cols}}/).join("\n")
  end

  def squares
    @squares ||= ('.' * cols * rows).chars
  end

  def add_all_claims(array_of_claims)
    array_of_claims.each do |string|
      claim = Claim.new(string)
      claims << claim
      self.rows = claim.min_rectangle_height if rows < claim.min_rectangle_height
      self.cols = claim.min_rectangle_width if cols < claim.min_rectangle_width
    end
  end

  # Place each claim on the rectangle
  def position_claims
    claims.each do |claim|
      claim_squares(claim)
    end
  end

  def claim_squares(claim)
    claim.positions(max_width: cols).each do |position|
      squares[position] = squares[position] == '.' ? claim.id : 'x'
    end
  end

  def no_overlapping_id
    claims.each do |claim|
      expected = claim.positions.size
      found = squares.count(claim.id)
      return claim.id if found == expected
    end
  end

  def overlaps_count
    @squares.count('x')
  end
end
