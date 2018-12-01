require 'minitest/autorun'
require_relative 'day20'

# Tests for particle swarms
class SwarmTest < Minitest::Test
  def test_parsing
    i = 'p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>'
    s = Swarm.new(i)
    assert_equal [3, 0, 0], s.particles[0].position
    assert_equal [2, 0, 0], s.particles[0].velocity
    assert_equal [-1, 0, 0], s.particles[0].acceleration
  end

  def test_distance_from_origo
    i = 'p=< 3,-1,2>, v=< 2,0,0>, a=<-1,0,0>'
    s = Swarm.new(i)
    assert s.particles[0].position == [3, -1, 2]
    assert s.particles[0].distance_from_origo == 6
  end

  def test_move
    i = 'p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>'
    s = Swarm.new(i)
    3.times { s.move }
    assert_equal 3, s.particles[0].distance_from_origo
  end

  def test_example_part_one
    i = "p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>\np=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>"
    s = Swarm.new(i)
    3.times do
      s.move
    end
    assert 1, s.closest
    1000.times do
      s.move
    end
    assert 0, s.closest
  end

  def test_part_one
    s = Swarm.new(File.read('input.txt'))
    1_000.times do |i|
      print "#{i} of 1 000 \r"
      $stdout.flush
      s.move
    end
    assert_equal 125, s.closest
  end

  # 134 was too low
  def test_part_two
    s = Swarm.new(File.read('input.txt'), true)
    500.times do |i|
      print "#{i} of 500 \r"
      $stdout.flush
      s.move
    end
    assert_equal 461, s.particles.size
  end
end
