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
    increase_skip_size
  end

  def fold_string(string)
    64.times do
      string.chars.each do |number|
        fold(ascii_value(number))
      end
      [17, 31, 73, 47, 23].each do |number|
        fold(number)
      end
    end
  end

  def fold_array(array)
    array.each do |number|
      fold(number)
    end
  end

  def increase_skip_size
    self.skip_size += 1
  end

  def move_forward(number)
    (number + skip_size).times do
      self.position = (position + 1) % list.size
    end
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
    l = list
    output = ''
    while l.any?
      output += format('%02x', bitwise_xor(l))
      l.slice!(0, 16)
    end
    output
  end

  def bitwise_xor(l)
    l[0] ^ l[1] ^ l[2] ^ l[3] ^
      l[4] ^ l[5] ^ l[6] ^ l[7] ^
      l[8] ^ l[9] ^ l[10] ^ l[11] ^
      l[12] ^ l[13] ^ l[14] ^ l[15]
  end
end
