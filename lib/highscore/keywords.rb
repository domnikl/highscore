# external
require 'digest/sha1'

module Highscore

  # keywords that were found in content
  #
  class Keywords
    include Enumerable

    # find keywords in a piece of content
    def self.find_keywords content, blacklist
      keywords = content.scan(/\w+/)
      keywords.delete_if do |x|
        x.match(/^[\d]+(\.[\d]+){0,1}$/) or x.length <= 2
      end

      keywords.delete_if do |key, value|
        blacklist.include?(key.downcase)
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
    # :call-seq:
    #   rank -> array
    #
    def rank
      sort
    end

    # get the top n keywords
    #
    def top n = 10
      rank[0..(n - 1)]
    end

    # add new keywords
    #
    def <<(keyword)
      key = Digest::SHA1.hexdigest(keyword.text)

      if @keywords.has_key?(key)
        @keywords[key].weight += keyword.weight
      else
        @keywords[key] = keyword
      end
    end

    # sort
    def sort
      sorted = @keywords.sort {|a,b| a[1] <=> b[1] }

      # convert Array from sort back to Array of Keyword objects
      sorted.collect {|x| x[1]}
    end

    # Enumerable
    #
    def each &block
      @keywords.each {|keyword| yield keyword[1] }
    end

    # number of Keywords given
    def length
      @keywords.length
    end

    # get the keyword with the highest rank
    def first
      sort.first
    end

    # get the keyword with the lowest rank
    def last
      sort.reverse.first
    end
  end
end