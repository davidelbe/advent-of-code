# Dance for letters
class Dance
  def initialize(input)
    @input = input.chars
    @out = input.chars
    @swaps = []
    @transforms = {}
  end

  def instructions=(input)
    @instructions = input.split(',')
    @comparison = @input.dup
    compile
  end

  def compile
    @instructions.each do |i|
      case i[0].to_s
      when 's'
        store_spin(i.tr('s', '').to_i)
      when 'x'
        store_exchange(i[1, i.length].split('/'))
      when 'p'
        store_partner(i[1, i.length].split('/'))
      end
    end
  end

  def moves
    @moves ||= @comparison.collect { |a| @input.index(a) }
  end

  def perform!
    tmp = @out.dup
    moves.each_with_index do |item, index|
      @out[index] = tmp[item]
    end
    @swaps.each do |s|
      do_swap(s)
    end
  end

  def store_spin(length)
    @comparison = @comparison[-1 * length, length]
                  .concat(@comparison[0, @comparison.length - length])
  end

  def do_swap(programs)
    indexes = [@out.index(programs[0].to_s), @out.index(programs[1].to_s)]
    a_value = @out[indexes[0].to_i]
    b_value = @out[indexes[1].to_i]
    @out[indexes[0].to_i] = b_value
    @out[indexes[1].to_i] = a_value
  end

  def store_exchange(indexes)
    a_value = @comparison[indexes[0].to_i]
    b_value = @comparison[indexes[1].to_i]
    @comparison[indexes[0].to_i] = b_value
    @comparison[indexes[1].to_i] = a_value
  end

  def store_partner(programs)
    @swaps << programs
  end

  def output
    @out.join
  end

  def cycle_length
    input = output.dup
    d = Dance.new(input)
    d.instructions = @instructions.dup.join(',')
    cycles = 0
    until input == d.output && cycles > 0
      d.perform!
      cycles += 1
    end
    cycles
  end

  def perform_n_times(n = 1)
    n = n % cycle_length if n > cycle_length
    n.times do
      perform!
    end
  end
end
