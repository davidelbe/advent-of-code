# Day 12 - Digital Plumber
class Plumber
  attr_accessor :input

  def initialize(input)
    self.input = input
  end

  def connections(numbers)
    added = 0
    numbers.each do |n|
      matches_for(n).each do |m|
        next if numbers.include?(m)
        numbers << m
        added += 1
      end
    end
    added > 0 ? connections(numbers) : numbers
  end

  def matches_for(number)
    input.scan(/^(\d{1,}) <->.* #{number}{1}[,\s]/).flatten.collect(&:to_i)
  end

  def lines
    input.split("\n")
  end

  def groups
    groups = 0
    while lines.any?
      number = first_number_in_input
      numbers = connections([number])
      delete_numbers_from_input(numbers)
      groups += 1
    end
    groups
  end

  def delete_numbers_from_input(numbers)
    numbers.each do |n|
      str = input.scan(/^(#{n}{1}.*)$/).flatten.first.to_s
      input.gsub!("#{str}\n", '') unless str.nil?
    end
  end

  def first_number_in_input
    lines[0].scan(/(\d{1,}) /).flatten.first.to_i
  end
end
