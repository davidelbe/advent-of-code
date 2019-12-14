require_relative 'intcode'
require 'curses'

program = Intcode.new([0], File.read('input.txt'))

include Curses
init_screen
start_color
init_pair(1, 1, 0)
init_pair(2, 2, 0)
curs_set(0)
noecho
win = Curses::Window.new(0, 0, 1, 2)

class Grid
  attr_accessor :coordinates, :height, :width, :ball, :pad, :score
  def initialize
    self.coordinates = []
    self.height = 0
    self.width = 0
    self.ball = 0
    self.pad = 0
    self.score = 0
  end

  def insert(x, y, id)
    if x == -1 && y == 0
      self.score = id
      return
    end
    self.height = y+1 if y >= height
    self.width = x+1 if x >= width
    coordinates[y] = [] if coordinates[y].nil?
    coordinates[y][x] = value_from(id)
    
    self.ball = x if value_from(id) == 'o'
    self.pad = x if value_from(id) == '~'
  end

  def value(x, y)
    return " " if coordinates[y].nil?
    return " " if coordinates[y][x].nil?

    coordinates[y][x]
  end

  def paint(window)
    (0..height).each do |y|
      (0..width).each do |x|
        if value(x, y) == 'o'
          window.attron(color_pair(1)) { window << '●' }
        elsif value(x, y) == '#'
          window.attron(color_pair(2)) { window << '■' }
        else
          window << value(x, y)
        end
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
    when 3 then '~'
    when 4 then 'o'
    end
  end
end

begin
  win = Curses::Window.new(0, 0, 1, 2)
  grid = Grid.new
  program.addresses[0] = 2

  loop do
    program.inputs = [grid.pad == grid.ball ? 0 : (grid.ball > grid.pad ? 1 : -1)]

    x = program.run(true).last
    y = program.run(true).last
    id = program.run(true).last
    grid.insert(x, y, id)

    win.setpos(0, 0)
    win = grid.paint(win)
    win.refresh
    sleep 0.01
    break if program.finished?
  end
ensure
  sleep 5
  close_screen
  puts "=== Part 2"
  puts grid.score
end
