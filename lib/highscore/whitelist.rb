$:.unshift(File.dirname(__FILE__))
require "wordlist"

module Highscore
  # whitelisted words
  #
  class Whitelist < Wordlist
    # filters a given keywords array
    #
    # @param Array keywords
    # @return Array
    def filter(keywords)
      keywords.delete_if do |key, value|
        not include?(key.downcase)
      end
    end
    
  end
end