# external
require 'digest/sha1'

module Highscore

  # keywords that were found in content
  #
  class Keywords
    include Enumerable

    # find keywords in a piece of content
    #
    # @param content String
    # @param wordlist Highscore::Wordlist
    # @param pattern Regex
    # @return Highscore::Keywords
    def self.find_keywords content, wordlist, pattern=/\w+/
      keywords = content.to_s.scan(pattern)
      keywords.delete_if do |key, value|
        if wordlist.kind_of? Highscore::Blacklist
          wordlist.include?(key.downcase)
        elsif wordlist.kind_of? Highscore::Whitelist
          not wordlist.include?(key.downcase)
        end
      end

      keywords.sort
    end

    # init a new keyword collection
    #
    def initialize
      @keywords = {}
    end

    # ranks the keywords and removes keywords that have a low ranking
    # or are blacklisted
    #
    # @return Array
    def rank
      sort
    end

    # get the top n keywords
    #
    # @param n Fixnum
    # @return Array
    def top n = 10
      rank[0..(n - 1)]
    end

    # add new keywords
    #
    # @param keyword String
    # @return Highscore::Keywords
    def <<(keyword)
      key = Digest::SHA1.hexdigest(keyword.text)

      if @keywords.has_key?(key)
        @keywords[key].weight += keyword.weight
      else
        @keywords[key] = keyword
      end

      @keywords
    end

    # sort
    #
    # @return Array
    def sort
      sorted = @keywords.sort {|a,b| a[1] <=> b[1] }

      # convert Array from sort back to Array of Keyword objects
      sorted.collect {|x| x[1]}
    end

    # Enumerable
    #
    def each
      @keywords.each {|keyword| yield keyword[1] }
    end

    # number of Keywords given
    #
    # @return Fixnum
    def length
      @keywords.length
    end

    # get the keyword with the highest rank
    #
    # @return Highscore::Keyword
    def first
      sort.first
    end

    # get the keyword with the lowest rank
    #
    # @return Highscore::Keyword
    def last
      sort.reverse.first
    end

    # merge in another keyword list, operates on self
    #
    # @return Highscore::Keywords
    def merge!(other)
      other.each do |keyword|
        self << keyword
      end

      self
    end
  end
end