require_relative 'intcode'
require 'curses'

input = File.read('input.txt')
program = Intcode.new([0], File.read('input.txt'))

include Curses
init_screen
curs_set(0)
noecho
win = Curses::Window.new(0, 0, 1, 2)

class Grid
  attr_accessor :coordinates, :height, :width
  def initialize
    self.coordinates = []
    self.height = 0
    self.width = 0
  end

  def insert(x, y, id)
    self.height = y if y > height
    self.width = x if x > height
    coordinates[y] = [] if coordinates[y].nil?
    coordinates[y][x] = value_from(id)
  end

  def value(x, y)
    return " " if coordinates[y].nil?
    return " " if coordinates[y][x].nil?

    coordinates[y][x]
  end

  def paint(window)
    (0..height).each do |y|
      (0..width).each do |x|
        window << value(x, y)
      end
      window << "\n"
    end
    window
  end

  def value_from(id)
    case id.to_i
    when 0 then ' '
    when 1 then '#'
    when 2 then '='
    when 3 then '-'
    when 4 then 'o'
    end
  end
end

begin
  win = Curses::Window.new(0, 0, 1, 2)
  grid = Grid.new

  loop do
    x = program.run(true).last
    y = program.run(true).last
    id = program.run(true).last
    grid.insert(x, y, id)
    win.setpos(0, 0)
    win = grid.paint(win)
    win.refresh
    break if program.finished?
  end
ensure
  sleep 5
  close_screen
  puts grid.coordinates.flatten.select{ |c| c == '=' }.count
end
