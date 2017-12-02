class CorruptionChecksum
	def checksum(input)
    lines = input.split("\n")
    lines.collect{ |l| line_checksum(l) }.inject(0, :+)
  end

  def line_checksum(line)
    digits = line.split(" ").collect(&:to_i)
    digits.max - digits.min
  end

  def division_checksum(input)
    lines = input.split("\n")
    lines.collect { |l| line_division_checksum(l) }.inject(0, :+)
  end

  def line_division_checksum(line)
    digits = line.split(" ").collect(&:to_i)
    digits.each_with_index do |digit, index|
      friends = digits.dup
      friends.delete_at(index)
      divided = friends.collect{ |f| digit / f if digit % f == 0 }.compact
      next unless divided.any?
      return divided.first
    end
  end
end

input = File.read("day2_input.txt")
checker = CorruptionChecksum.new
puts checker.checksum(input)
puts checker.division_checksum(input)
