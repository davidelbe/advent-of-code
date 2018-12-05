# Polymer class
class Polymer
  attr_accessor :result
  def initialize(input)
    self.result = input
  end

  def reactions
    %w[aA Aa bB Bb cC Cc dD Dd eE Ee fF Ff gG Gg
       hH Hh iI Ii jJ Jj kK Kk lL Ll mM Mm nN Nn
       oO Oo pP Pp qQ Qq rR Rr sS Ss tT Tt uU Uu
       vV Vv wW Ww xX Xx yY Yy zZ Zz]
  end

  def react
    count = result.size
    reactions.map { |reaction| result.gsub!(reaction, '') }
    return count if result.size == count

    react
  end
end

# Compare unit removals
class PolymerUnitRemover
  attr_accessor :lowest_count, :input
  def initialize(input)
    self.lowest_count = 999_999_999
    self.input = input
    compare
  end

  def compare
    ('a'..'z').to_a.each do |char|
      count = Polymer.new(test_input(char)).react
      self.lowest_count = count if count < lowest_count
    end
    lowest_count
  end

  def test_input(char)
    input.tr(char.upcase, '').tr(char, '')
  end
end
