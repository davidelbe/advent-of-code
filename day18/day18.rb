# Duet
class Duet
  attr_accessor :input, :partner, :state, :sent

  def initialize(input)
    @registers = {}
    @queue = []
    input.scan(/^[a-z]{3}\s(\w{1,})/).flatten.uniq.each do |r|
      @registers[r] = 0
    end
    self.input = input.split("\n")
  end

  def play_with(program, starting_value)
    self.partner = program
    self.sent = 0
    @registers['p'] = starting_value
    parse
  end

  def parse
    self.state = 'running'
    @position = 0
    send(
      input[@position][0, 3].to_sym,
      name_and_value(input[@position])
    ) while inside_registers?
    self.state = 'waiting'
  end

  def snd(args)
    puts "sending #{read_value(args[0])} to partner"
    self.sent += 1
    partner.receive(read_value(args[0]))
    @position += 1
  end

  def set(args)
    @registers[args[0]] = args[1]
    @position += 1
  end

  def add(args)
    @registers[args[0]] += args[1]
    @position += 1
  end

  def mul(args)
    @registers[args[0]] *= args[1]
    @position += 1
  end

  def mod(args)
    @registers[args[0]] %= args[1]
    @position += 1
  end

  # Just store it for later processing
  def receive(number)
    puts "received number #{number}"
    @queue << number
  end

  def rcv(args)
    return @position = -1 if state == 'waiting' && partner.state == 'waiting'
    self.state = 'waiting'
    return if @queue.empty?
    self.state = 'running'
    @registers[args[0]] = @queue.slice!(0)
    @position += 1
  end

  def jgz(args)
    value_of_x = read_value(args[0])
    return @position += 1 if value_of_x <= 0
    @position += args[1]
  end

  def name_and_value(line)
    [line.split(' ')[1], read_value(line.split(' ').last)]
  end

  def inside_registers?
    return false if @position < 0
    return false if @position > input.size - 1
    true
  end

  def read_value(number_or_letter)
    Float(number_or_letter)
    number_or_letter.to_i
  rescue ArgumentError
    @registers[number_or_letter]
  end
end
