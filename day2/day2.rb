class CorruptionChecksum
	def checksum(input)
    lines = input.split("\n")
    lines.collect{ |l| line_checksum(l) }.inject(0, :+)
  end

  def line_checksum(line)
    digits = line.split(" ").collect(&:to_i)
    digits.max - digits.min
  end
end

input = File.read("day2_input.txt")
checker = CorruptionChecksum.new
puts checker.checksum(input)
