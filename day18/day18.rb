# Duet
class Duet
  attr_accessor :input, :recovered_frequency

  def initialize(input)
    @registers = {}
    @recovers = {}
    input.scan(/^[a-z]{3}\s(\w{1,})/).flatten.uniq.each do |r|
      @registers[r] = 0
      @recovers[r] = 0
    end
    self.input = input.split("\n")
  end

  def parse
    @position = 0
    send(
      input[@position][0, 3].to_sym,
      name_and_value(input[@position])
    ) while inside_registers?
  end

  def snd(args)
    @last_sound_played = args[1]
    @last_sound_played_name = args[0]
    @recovers[args[0]] = @last_sound_played
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

  def rcv(args)
    return @position += 1 if read_value(args[0]).zero?
    @registers[@last_sound_played_name] = @recovers[@last_sound_played_name]
    self.recovered_frequency = @last_sound_played
    @position = -1
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
