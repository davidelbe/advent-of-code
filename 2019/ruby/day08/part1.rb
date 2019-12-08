numbers = File.read('input.txt').chars.map(&:to_i)
fewest_zeroes = nil
result = 0
# 25 pixels wide and 6 pixels tall
while numbers.any?
  layer = numbers.slice!(0, 25 * 6)
  zeroes = layer.count(0)
  if fewest_zeroes.nil? || zeroes < fewest_zeroes
    fewest_zeroes = zeroes
    result = layer.count(1) * layer.count(2)
  end
end

puts "Part 1: #{result}"
