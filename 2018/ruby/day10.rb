# A single point
class Point
  attr_accessor :x, :y, :vx, :vy

  def neighbours(all_positions)
    positions = [[x - 1, y], [x + 1, y], [x - 1, y - 1], [x, y - 1], [x + 1, y - 1], [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]]
    positions.map { |position| all_positions.include?(position) }
  end
end

@points = []

File.read('day10.txt').split("\n").each do |line|
  pos = line.scan(/<\s{0,}(-{0,1}\d{1,}),\s{0,}(-{0,1}\d{1,})>/)
  p = Point.new
  p.x = pos.first.first.to_i
  p.y = pos.first.last.to_i
  p.vx = pos.last.first.to_i
  p.vy = pos.last.last.to_i

  @points << p
end

def print_points(_number)
  point_array = @points.map { |p| [p.x, p.y] }
  (0...200).each do |y|
    l = (0...200).map { |x| point_array.include?([x, y]) ? '#' : '.' }.join
    puts l if l.include?('#')
  end
end

def all_have_neighbours?
  @points.map { |p| p.neighbours(@points.map { |p| [p.x, p.y] }).any? }.all?(true)
end

iteration = 0
loop do
  iteration += 1
  all_positive = true

  @points.each do |point|
    point.x += point.vx
    point.y += point.vy
    all_positive = false if point.x < 0 || point.y < 0
  end

  next unless all_positive
  next unless all_have_neighbours?

  puts 'Part 1: ⬇'
  print_points(iteration)
  puts "Part 2: #{iteration}"
  break
end
