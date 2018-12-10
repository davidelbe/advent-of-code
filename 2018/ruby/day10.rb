class Point
  attr_accessor :x, :y, :vx, :vy
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

def print_points(number)
#  puts "\e[H\e[2J" # clear screen
#  puts number
  point_array = @points.map{ |p| [p.x, p.y]}
    (0...256).each do |y|
      l = (0...256).map {|x| point_array.include?([x, y]) ? '#' : '.' }.join
      if l == '...............................................................................................................#.......#####....####...#####...#####...#....#..######..######...................................................................................'
        puts "Part 2: #{number+1}"
        puts "Part 1: ⬇"
      end
      puts l if l.include?('#')
      Process.exit if l == '...............................................................................................................######..#....#...###.#..#.......#####...#....#..######..######...................................................................................'
    end
end

200_000.times do |iteration|
#  puts iteration
  all_positive = true
    @points.each do |point|
      point.x += point.vx
      point.y += point.vy
      if point.x < 0 || point.y < 0
        all_positive = false
      end
    end

  if iteration > 10000 && iteration < 10500
    print_points(iteration) if all_positive
  end

end


