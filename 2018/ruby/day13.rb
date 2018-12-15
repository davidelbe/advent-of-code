class Cart
  attr_accessor :x, :y, :xv, :yv, :turn, :crashed
  def initialize(x, y, xv, yv)
    @x = x
    @y = y
    @xv = xv
    @yv = yv
    @turn = 0
    @crashed = false
  end

  # starting from top, y is much more
  # valuable than x, 1000 should be a big enough number
  def sorter
    y * 1000 + x
  end
end

carts = []

grid = File.read('day13.txt').split("\n").map(&:chars)
grid.each_with_index do |row, y|
  row.each_with_index do |item, x|
    case item
    when '<' then carts << Cart.new(x, y, -1, 0); '-'
    when '>' then carts << Cart.new(x, y, 1, 0); '-'
    when '^' then carts << Cart.new(x, y, 0, -1); '|'
    when 'v' then carts << Cart.new(x, y, 0, 1); '|'
    else item
    end
  end
end

print_grid(grid)

def print_grid(grid)
  puts ""
  grid.each do |row|
    puts row.join
  end
  puts ""
end

loop do
  carts.sort_by!(&:sorter)
  carts.each do |cart|
    next if cart.crashed

    new_cart_x = cart.x + cart.xv
    new_cart_y = cart.y + cart.yv

    crash = carts.find do |other_cart|
      other_cart.x == new_cart_x &&
      other_cart.y == new_cart_y &&
      !other_cart.crashed
    end

    if crash
      puts "Cart crashed at: #{new_cart_x},#{new_cart_y}"
      cart.crashed = true
      crash.crashed = true
      next
    end
    cart.x = new_cart_x
    cart.y = new_cart_y

    case grid[cart.y][cart.x]
    when "\\"
      then cart.xv, cart.yv = cart.yv, cart.xv
    when '/' then cart.xv, cart.yv = -cart.yv, -cart.xv
    when '+'
      case cart.turn
      when 0 then cart.xv, cart.yv = cart.yv, -cart.xv
      when 2 then cart.xv, cart.yv = -cart.yv, cart.xv
      end
      cart.turn = (cart.turn + 1) % 3
    end
  end

  remaining_carts = carts.reject(&:crashed)

  next if remaining_carts.size != 1

  cart = remaining_carts[0]
  puts "Remaining cart is at: #{cart.x},#{cart.y}"
  exit
end
