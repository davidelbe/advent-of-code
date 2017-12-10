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
end
