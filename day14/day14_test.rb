require 'minitest/autorun'
require_relative 'day14'

# Test cases for defrag class
class DefragTest < Minitest::Test
  def test_hash_conversion
    d = Defrag.new 'a0c2017'
    assert_equal '1110', d.bits_from_char('e')
    assert_equal '0001', d.bits_from_char('1')
  end

  def test_used_bits
    d = Defrag.new 'flqrgnkx'
    assert_equal 8108, d.used_bits
  end

  def test_part_one
    d = Defrag.new 'uugsqrei'
    assert_equal 8194, d.used_bits
  end

  def test_groups
    d = Defrag.new 'flqrgnkx'
    assert_equal 1242, d.groups
  end

  def test_part_two
    d = Defrag.new 'uugsqrei'
    assert_equal 1141, d.groups
  end
end
