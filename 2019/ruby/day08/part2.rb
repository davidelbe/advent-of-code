numbers = File.read('input.txt').chars.map(&:to_i)
image = Array.new(25 * 6, 2)  

while numbers.any?
  layer = numbers.slice!(0, 25 * 6)
  layer.each_with_index do |pixel, index|
    image[index] = pixel if image[index] == 2
  end
end

6.times do 
  puts image.slice!(0, 25).map{ |c| c == 0 ? "🏴" : "🏳️" }.join
end

# 🏳️🏴🏴🏴🏳️🏳️🏴🏴🏴🏴🏳️🏳️🏳️🏳️🏴🏳️🏳️🏳️🏴🏴🏴🏴🏳️🏳️🏴
# 🏳️🏴🏴🏴🏳️🏳️🏴🏴🏴🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏳️🏴🏴🏴🏴🏳️🏴
# 🏴🏳️🏴🏳️🏴🏳️🏴🏴🏴🏴🏳️🏳️🏳️🏴🏴🏳️🏴🏴🏳️🏴🏴🏴🏴🏳️🏴
# 🏴🏴🏳️🏴🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏴🏴🏳️🏳️🏳️🏴🏴🏴🏴🏴🏳️🏴
# 🏴🏴🏳️🏴🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏳️🏴
# 🏴🏴🏳️🏴🏴🏳️🏳️🏳️🏳️🏴🏳️🏴🏴🏴🏴🏳️🏴🏴🏴🏴🏴🏳️🏳️🏴🏴
