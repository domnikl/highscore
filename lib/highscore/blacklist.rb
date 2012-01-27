module Highscore

  # blacklisted words to be ignored in the resulting keywords
  #
  class Blacklist
    include Enumerable

    # load a file of keywords
    def self.load_file file_path
      words = File.read(file_path).split(' ')
      self.load(words)
    end

    # load default file
    #
    def self.load_default_file
      file_path = File.join(File.dirname(__FILE__), %w{.. blacklist.txt})
      self.load_file(file_path)
    end

    # load a file or array of words
    #
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

    def initialize(words = [])
      @words = words
    end

    # iterate over words
    #
    def each
      @words.each {|x| yield x }
    end

    # count of ignored words
    def length
      @words.length
    end

    # get an array of blacklisted words
    #
    def to_a
      @words.to_a
    end

    # does the blacklist contain this keyword?
    #
    def include? keyword
      @words.include? keyword
    end

    # add a new word to the blacklist
    def <<(word)
      @words << word
    end

  end
end