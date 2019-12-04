class Password
  attr_accessor :password

  def initialize(input)
    self.password = input.to_s
  end

  def valid?
    return false unless password.chars.size == 6
    return false if password.chars.sort != password.chars
    return false if password.chars.uniq == password.chars

    double_digits?
  end

  def double_digits?
    0.upto(9).each do |number|
      return true if password.tr(number.to_s, '').chars.size == 4
    end
    false
  end
end

require 'minitest/autorun'
class PasswordTest < Minitest::Test
  def test_larger_group
    assert Password.new('112233').valid?
    refute Password.new('123444').valid?
    assert Password.new('111122').valid?
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
puts "Part 2: #{counter}"
