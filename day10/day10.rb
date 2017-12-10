# Folding
class Knot
  attr_accessor :list, :skip_size, :position

  def initialize(input)
    self.list = input
    self.skip_size = 0
    self.position = 0
  end

  def fold(number)
    return false if number > list.size
    reverse_interval(number)
    move_forward(number)
    self.skip_size += 1
  end

  def fold_string(string)
    suffix_values = [17, 31, 73, 47, 23]
    array = string.chars.collect { |n| ascii_value(n) }.concat(suffix_values)
    64.times do
      fold_array(array)
    end
  end

  def fold_array(array)
    array.each do |number|
      fold(number)
    end
  end

  def move_forward(number)
    self.position = (position + number + skip_size) % list.size
  end

  def reverse_interval(number)
    list.rotate!(position)
    list.unshift(list.slice!(0, number).reverse).flatten!
    list.rotate!(position * -1)
  end

  def checksum
    list[0] * list[1]
  end

  def ascii_value(number)
    number.to_s.ord
  end

  def dense_hash
    output = ''
    while list.any?
      output += format('%02x', bitwise_xor(list))
      list.slice!(0, 16)
    end
    output
  end

  def bitwise_xor(l)
    l[0..15].inject(:^)
  end
end
