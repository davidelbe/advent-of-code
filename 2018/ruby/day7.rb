# Main class responsible for solving all instructions
class Assembly
  attr_accessor :steps, :elapsed_seconds, :workers

  def initialize(input)
    self.steps = {}
    scanned_steps(input).each do |pair|
      step = pair.last
      requirement = pair.first
      add_step(step, requirement)
      add_step(requirement, nil)
    end
  end

  def initialize_workers(workers_count)
    self.workers = []
    workers_count.times do
      workers << Worker.new(nil, 0)
    end
  end

  def already_solving?(letter)
    workers.map(&:letter).include?(letter)
  end

  def release_workers
    workers.each do |w|
      if w.done?
        w.seconds_left = 0
        steps[w.letter].solved = true if w.letter
        w.letter = nil
      else
        w.seconds_left -= 1
      end
    end
  end

  def add_to_worker(letter, starting_seconds)
    workers.each do |w|
      next unless w.done?

      w.seconds_left = starting_seconds
      w.letter = letter
      break
    end
  end

  def print_workers
    puts "#{elapsed_seconds} #{workers.map(&:letter).join(" ")}"
  end

  def solve_with_workers(workers_count, starting_seconds)
    self.elapsed_seconds = 0
    initialize_workers(workers_count)
    loop do
      ('A'..'Z').to_a.each_with_index do |step_letter, index|
        step = steps[step_letter]
        next if step.nil? || step.solved? || !step_solveable?(step)
        next if already_solving?(step_letter)

        add_to_worker(step_letter, starting_seconds + index + 1)
      end
      self.elapsed_seconds += 1
      print_workers
      release_workers
      break if steps.values.map(&:solved?).uniq == [true]
    end
    elapsed_seconds
  end

  def solve
    solved = ''
    loop do
      changed = false
      ('A'..'Z').to_a.each do |step_letter|
        step = steps[step_letter]
        next if step.nil?
        next if step.solved?
        next unless step_solveable?(step)

        changed = true
        step.solved = true
        solved += step.name

        break
      end
      break unless changed
    end
    solved
  end

  def scanned_steps(input)
    input.scan(/Step (\D) .*step (\D)/)
  end

  def add_step(step, requirement)
    if steps.key?(step)
      steps[step].requirements << requirement
    else
      steps[step] = Step.new(step, requirement)
    end
    steps[step].requirements.compact!
  end


  def step_solveable?(step)
    return false if step.requirements.map { |r| steps[r].solved? }.include?(false)

    true
  end
end

class Step
  attr_accessor :requirements, :name, :solved

  def initialize(step, requirement)
    self.name = step
    self.requirements = [requirement]
    self.solved = false
  end

  def solved?
    solved
  end
end

class Worker
  attr_accessor :seconds_left, :letter
  def initialize(letter, seconds_left)
    self.letter = letter
    self.seconds_left = seconds_left
  end

  def done?
    self.seconds_left <= 1
  end
end
