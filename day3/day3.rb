require "matrix"

class SpiralMemory
  def distance_to(input, from = 1)
    @number = input.to_i if @number.nil?
    x1, y1 = matrix.index(input)
    x2, y2 = matrix.index(from)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def value_of(input)
    @number = input
    value_array[input - 1]
  end

  def matrix
    @matrix ||= Matrix[*build_matrix]
  end

  def value_array
    @value_array ||= build_value_array
  end

  # return all neighbouring cells
  def neighbours(number)
    x, y = matrix.index(number)
    [ 
      matrix[x,   y-1],
      matrix[x,   y+1],
      matrix[x-1, y],
      matrix[x+1, y],
      matrix[x+1, y+1],
      matrix[x+1, y-1],
      matrix[x-1, y-1],
      matrix[x-1, y+1]
    ].compact.uniq.delete_if { |cell|
      x2, y2 = matrix.index(cell)
      (x2 - x).abs > 1 || (y2 - y).abs > 1 || cell == number
    }
  end

  def build_matrix
    n = Math.sqrt(@number).ceil
    m = Array.new(n){ Array.new(n) }
    position = n * n + 1
    side = n
    for i in 0 .. (n-1)/2
      (0...side).each{ |j| m[i][i+j]     = (position -= 1) }
      (1...side).each{ |j| m[i+j][n-1-i] = (position -= 1) }
      side -= 2
      side.downto(0) { |j| m[n-1-i][i+j] = (position -= 1) }
      side.downto(1) { |j| m[i+j][i]     = (position -= 1) }
    end
    m
  end

  def build_value_array
    # start with an array one 1 and many 0's
    values = [1] + Array.new(@number, 0)
    2.upto(@number) do |number|
      sum = 0
      neighbours(number).each do |n|
        sum += values[n - 1].to_i
        raise "Answer is #{sum}" if sum > @number
      end
      values[number - 1] = sum
    end
    values
  end
end
