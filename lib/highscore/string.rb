require 'whatlanguage'

# monkey patch to call custom methods on arbitrary strings
#
class String

  # get keywords from the string
  #
  # @param wordlist Highscore::Wordlist
  # @param block Block
  # @return Highscore::Keywords
  def keywords(wordlist = nil, &block)
    content = Highscore::Content.new(self, wordlist)

    if block_given?
      content.configure do
        content.instance_eval(&block)
      end
    end

    content.keywords
  end

  # get all vowels from a string
  #
  # @return String
  def vowels
    gsub(/[^aeiou]/, '')
  end

  # get all consonants from a string
  #
  # @return String
  def consonants
    gsub(/[aeiou]/, '')
  end

  # is this a short word?
  #
  # @return TrueClass|FalseClass
  def short?(limit=2)
    match(/^[\d]+(\.[\d]+){0,#{limit - 1}}$/) or length <= limit
  end
end