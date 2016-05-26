module Highscore

  # a basic list of words
  class Wordlist
    include Enumerable

    # load a file of keywords
    #
    # @param file_path String
    # @return Highscore::Wordlist
    def self.load_file(file_path, use_bloom_filter = true)
      words = File.read(file_path).split(' ')
      self.load(words, use_bloom_filter)
    end

    # load a file or array of words
    #
    # @param data String Array
    # @return Highscore::Wordlist
    def self.load(data, use_bloom_filter = true)
      if data.instance_of?(String)
        words = data.split(' ')
      elsif data.instance_of? Array
        words = data
      else
        raise ArgumentError, "don't know how to handle a %s class" % data.class
      end

      words.map! {|x| x.gsub(/[\!\.\:\,\;\-\+]/, '') }

      self.new(words, use_bloom_filter)
    end

    attr_reader :words

    # @param words Array
    def initialize(words = [], use_bloom_filter = true)
      @words = words
      @bloom_filter = nil
      @use_bloom_filter = use_bloom_filter

      init_bloom_filter
    end

    # iterate over words
    #
    def each
      @words.each {|word| yield word }
    end

    # count of ignored words
    #
    # @return Fixnum
    def length
      @words.length
    end

    # get an array of blacklisted words
    #
    # @return Array
    def to_a
      @words.to_a
    end

    # does the blacklist contain this keyword?
    #
    # @param keyword String
    # @return true/false
    def include?(keyword)
      unless @bloom_filter.nil?
        @bloom_filter.include? keyword
      else
        @words.include? keyword
      end
    end

    # add a new word to the blacklist
    #
    # @param word String
    def <<(word)
      @words << word
      @bloom_filter << word unless @bloom_filter.nil?
    end

  private

    # determine whether bloom filters should be used
    def use_bloom_filter
      return false unless @use_bloom_filter

      begin
        require 'bloomfilter-rb'
        true
      rescue LoadError
        false
      end
    end

    # build a bloom filter out of this wordlist to determine faster
    # if words should be black- or whitelisted
    #
    def init_bloom_filter
      return unless use_bloom_filter

      n = length # number of filter elements

      if n > 0
        b = 4  # bits per bucket
        m = n * b * 10 # number of filter buckets

        k = (0.7 * (m / n)).to_i # number of hash functions
        k = 1 if k <= 1

        @bloom_filter = BloomFilter::Native.new(:size => m, :bucket => b, :raise => true, :hashes => k)
        each { |w| @bloom_filter.insert(w) }
      end
    end

  end
end
