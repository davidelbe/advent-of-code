class Password
  attr_accessor :password

  def initialize(input)
    self.password = input.to_s
  end

  def valid?
    return false unless password.chars.size == 6
    return false if password.chars.sort != password.chars
    return false if password.chars.uniq == password.chars

    true
  end
end

require 'minitest/autorun'
class PasswordTest < Minitest::Test
  def test_length_incorrect
    p = Password.new('1111111')
    refute p.valid?
  end

  def test_length_correct
    p = Password.new('111111')
    assert p.valid?
  end

  def test_never_decrease
    refute Password.new('223450').valid?
  end

  def test_no_doubles
    refute Password.new('123789').valid?
  end
end

input = '134792-675810'
start = input.split('-')[0]
stop = input.split('-')[1]
counter = 0
start.upto(stop).each do |number|
  counter += 1 if Password.new(number).valid?
end
puts "== Day 4, 2019"
puts "Part 1: #{counter}"
