class Abbreviate
  attr_reader :name

  STOP_WORDS = %w(e ou para de da que)

  # Adapted from http://stackoverflow.com/a/267405
  ROMAN_NUMERALS_REGEX = /^((XC|XL|L?X{0,3})(IX|IV|V?I{0,3}))$/i

  def self.abbreviate(name)
    new(name).abbreviate
  end

  def initialize(name)
    @name = name
  end

  def abbreviate
    name
      .split
      .reject { |word| STOP_WORDS.include?(word.downcase)  }
      .map    { |word| (word =~ ROMAN_NUMERALS_REGEX ? word : word[0]).upcase }
      .join
      .slice(0..9)
  end
end
