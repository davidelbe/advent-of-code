require 'minitest/autorun'
require_relative 'day8'

# Test for Register class
class RegisterTest < Minitest::Test
  def test_example_input
    example_register = Register.new(File.read('example_input.txt'))
    example_register.follow_instructions
    assert_equal 1, example_register.max_register_value
    assert_equal 10, example_register.max_value
  end

  def test_real_input
    example_register = Register.new(File.read('input.txt'))
    example_register.follow_instructions
    assert_equal 4567, example_register.max_register_value
    assert_equal 5636, example_register.max_value
  end
end
