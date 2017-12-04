# Day 4: High-Entropy Passphrases
require "minitest/autorun"
require_relative "day4.rb"

class PassphraseTest < Minitest::Test

  def valid_passphrases
    [ "aa bb cc dd ee", "aa bb cc dd aaa", "abcde fghij", 
      "iiii oiii ooii oooi oooo", "a ab abc abd abf abj" ]
  end

  def invalid_passphrases
    ["aa bb cc dd aa", "abcde xyz ecdab", "oiii ioii iioi iiio"]
  end

  def test_valid_passphrases
    valid_passphrases.each do |p|
      passphrase = Passphrase.new(p)
      assert passphrase.strict_valid?, "#{p} is not valid but should be"
    end
  end

  def test_invalid_passphrase
    invalid_passphrases.each do |p|
      passphrase = Passphrase.new(p)
      assert !passphrase.strict_valid?, "#{p} is valid but should not be"
    end
  end

  def test_invalid_passphrase_in_file
    valid_count = 0
    strict_valid_count = 0
    File.readlines('day4_input.txt').each do |line|
      valid_count += 1 if Passphrase.new(line).valid?
      strict_valid_count += 1 if Passphrase.new(line).strict_valid?
    end
    assert_equal 455, valid_count
    assert_equal 186, strict_valid_count  
  end
end
