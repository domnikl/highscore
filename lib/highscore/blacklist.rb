$:.unshift(File.dirname(__FILE__))
require "wordlist"

module Highscore

  # blacklisted words to be ignored in the resulting keywords
  #
  class Blacklist < Wordlist

    # load default file
    #
    # @return Highscore::Blacklist
    def self.load_default_file
      file_path = File.join(File.dirname(__FILE__), %w{.. blacklist.txt})
      self.load_file(file_path)
    end
    
    # filters a given keywords array
    #
    # @param Array keywords
    # @return Array
    def filter(keywords)
      keywords.delete_if do |key, value|
        include?(key.downcase)
      end
    end
    
    
  end
end