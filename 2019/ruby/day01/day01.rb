class RocketModule
  attr_accessor :mass

  def initialize(mass: 0)
    self.mass = mass
  end

  def fuel_required
    (mass / 3.0).floor - 2
  end

  def all_fuel
    return 0 if fuel_required <= 0

    fuel_required + RocketModule.new(mass: fuel_required.to_i).all_fuel
  end
end

class FuelRequirementCalculator
  attr_accessor :modules

  def initialize(input)
    self.modules = []
    input.split("\n").each do |line|
      self.modules << RocketModule.new(mass: line.to_i)
    end
  end

  def fuel_requirement
    modules.map { |m| m.fuel_required }.sum
  end

  def full_fuel_requirement
    modules.map { |m| m.all_fuel }.sum
  end
end

# Part 1
# usage: ruby day01.rb
calculator = FuelRequirementCalculator.new(File.read('day01_input.txt'))
puts "== Part 1"
puts "Fuel required: #{calculator.fuel_requirement}"

puts "== Part 2"
puts "Fuel required: #{calculator.full_fuel_requirement}"

