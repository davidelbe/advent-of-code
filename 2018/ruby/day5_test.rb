require 'minitest/autorun'
require_relative 'day5.rb'

# test polymer
class PolymerTest < Minitest::Test
  def test_example_part_one
    input = 'dabAcCaCBAcCcaDA'
    polymer = Polymer.new(input)

    polymer.react

    assert_equal 'dabCBAcaDA', polymer.result.join
    assert_equal 10, polymer.result.size
  end

  def test_part_one
    input = File.read('day5.txt')
    polymer = Polymer.new(input)

    polymer.react

    assert_equal 9_238, polymer.result.size
  end
end

# Test polymer unit removal
class PolymerUnitRemoverTest < Minitest::Test
  def test_example_part_two
    input = 'dabAcCaCBAcCcaDA'
    remover = PolymerUnitRemover.new(input)

    assert_equal 4, remover.compare
  end

  def test_part_two
    input = File.read('day5.txt')
    remover = PolymerUnitRemover.new(input)

    assert_equal 4_052, remover.compare
  end
end
