# Day 9: Stream Processing
class Stream
  attr_accessor :stream

  def initialize(input)
    self.stream = input
    remove_ignored
  end

  def remove_ignored
    stream.gsub!(/(!.{1})/, '')
  end

  def clean!(replace_with = '')
    stream.gsub!(/<([^>]{0,}>)/, replace_with)
  end

  def score
    accumulated_score = 0
    level = 0
    while groups.any?
      level += 1
      accumulated_score += (level * groups.size)
      self.stream = groups.collect { |c| c[1..-2] }.join(', ')
    end
    accumulated_score
  end

  def groups
    stream.scan(/(\{(?>[^}{]+|\g<1>)*\})/).flatten
  end
end
