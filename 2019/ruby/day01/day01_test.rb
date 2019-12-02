require 'minitest/autorun'
require_relative 'day01.rb'

# test FrequencyChange
class RocketModuleTest < Minitest::Test
  def test_mass
    assert_equal 2, module_with_mass(12).fuel_required
    assert_equal 2, module_with_mass(14).fuel_required
    assert_equal 654, module_with_mass(1_969).fuel_required
    assert_equal 33_583, module_with_mass(100_756).fuel_required
  end

  def test_mass_recursive
    assert_equal 2, module_with_mass(14).all_fuel
    assert_equal 966, module_with_mass(1_969).all_fuel
    assert_equal 50_346, module_with_mass(100_756).all_fuel
  end

  def module_with_mass(mass)
    RocketModule.new(mass: mass.to_i)
  end
end
