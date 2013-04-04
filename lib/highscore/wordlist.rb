module Highscore

  # a basic list of words
  class Wordlist
    include Enumerable

    # load a file of keywords
    #
    # @param file_path String
    # @return Highscore::Wordlist
    def self.load_file file_path
      words = File.read(file_path).split(' ')
      self.load(words)
    end

    # load a file or array of words
    #
    # @param data String Array
    # @return Highscore::Wordlist
    def self.load(data)
      if data.instance_of?(String)
        words = data.split(' ')
      elsif data.instance_of? Array
        words = data
      else
        raise ArgumentError, "don't know how to handle a %s class" % data.class
      end

      words.map! {|x| x.gsub(/[\!\.\:\,\;\-\+]/, '') }

      self.new(words)
    end

    attr_reader :words

    # @param words Array
    def initialize(words = [])
      @words = words
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
      @words.include? keyword
    end

    # add a new word to the blacklist
    #
    # @param word String
    def <<(word)
      @words << word
    end
  end
end