class Passphrase
  def initialize(input)
    @phrase = input
  end

  def valid?
    parts.uniq.size == parts.size
  end

  def strict_valid?
    new_parts = []
    parts.each_with_index do |part, index|
      new_parts << part.chars.sort.join
    end
    @phrase = new_parts.join(" ")
    valid?
  end

  def parts
    @phrase.split(" ")
  end
end
