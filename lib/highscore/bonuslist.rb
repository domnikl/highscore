$:.unshift(File.dirname(__FILE__))
require "wordlist"

module Highscore
  # Bonus words
  #
  class Bonuslist < Wordlist
    def filter(keywords)
      keywords
    end
  end
end