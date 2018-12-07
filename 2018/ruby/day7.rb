# Main class responsible for solving all instructions
class Assembly
  attr_accessor :steps

  def initialize(input)
    self.steps = {}
    scanned_steps(input).each do |pair|
      step = pair.last
      requirement = pair.first
      add_step(step, requirement)
      add_step(requirement, nil)
    end

    puts '=== STEPS ==='
    steps.sort.each do |key, step|
      puts "#{step.name} | #{step.requirements.sort.join}"
    end
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

