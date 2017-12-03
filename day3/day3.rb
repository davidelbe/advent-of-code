require "matrix"

class SpiralMemory
  def distance_to(input)
    @number = input.to_i
    x1, y1 = matrix.index(input)
    x2, y2 = matrix.index(1)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def matrix
    @matrix ||= Matrix[*build_matrix(@number)]
  end

  def build_matrix(input)
    n = Math.sqrt(input).ceil
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
end
