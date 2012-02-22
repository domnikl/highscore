$:.unshift(File.join(File.dirname(__FILE__)))
require 'keywords'

module Highscore
  class Content
    attr_reader :content

    # @param content String
    # @param wordlist Highscore::Wordlist
    def initialize(content, wordlist = nil)
      @content = content
      @whitelist = @blacklist = nil

      if wordlist.nil?
        @blacklist = Highscore::Blacklist.load_default_file
      elsif wordlist.kind_of? Highscore::Blacklist
        @blacklist = wordlist
      else
        @whitelist = wordlist
      end

      @emphasis = {
        :multiplier => 1.0,
        :upper_case => 3.0,
        :long_words => 2.0,
        :long_words_threshold => 15,
        :vowels => 0,
        :consonants => 0,
        :ignore_short_words => true,
        :ignore_case => false,
        :word_pattern => /\w+/
      }
    end

    # configure ranking
    #
    # @param block
    def configure(&block)
      instance_eval(&block)
    end

    # set emphasis options to rank the content
    #
    # @param key Symbol
    # @param value Object
    def set(key, value)
      @emphasis[key.to_sym] = value
    end

    # get the ranked keywords
    #
    # @return Highscore::Keywords
    def keywords
      keywords = Keywords.new

      Keywords.find_keywords(processed_content, wordlist, word_pattern).each do |text|
        text = text.to_s

        if not (text.match(/^[\d]+(\.[\d]+){0,1}$/) or text.length <= 2)
          keywords << Highscore::Keyword.new(text, weight(text))
        elsif allow_short_words
          keywords << Highscore::Keyword.new(text, weight(text))
        end
      end

      keywords
    end

    # get the used wordlist
    #
    # @return Highscore::Wordlist
    def wordlist
      unless @whitelist.nil?
        @whitelist
      else
        @blacklist
      end
    end

    private

    # processes the text content applying any necessary transformations
    #
    # @return String
    def processed_content
      "".tap do |result|
        result.replace(@content) # initialize the result to be @content
        result.replace(result.downcase) if @emphasis[:ignore_case]
      end
    end

    # allow short words to be rated
    #
    # @return TrueClass FalseClass
    def allow_short_words
      not @emphasis[:ignore_short_words]
    end

    # regex used to split text
    #
    # @return Regex
    def word_pattern
      @emphasis[:word_pattern]
    end

    # weight a single text keyword
    #
    # @param text String
    # @return Float
    def weight(text)
      weight = @emphasis[:multiplier]

      if text.length >= @emphasis[:long_words_threshold]
        weight *= @emphasis[:long_words]
      end

      if text[0,1] == text[0,1].upcase
        weight *= @emphasis[:upper_case]
      end

      weight += vowels(text)
      weight += consonants(text)
      weight
    end

    # weight the vowels on a text
    #
    # @param text String
    # @return Float
    def vowels(text)
      percent = text.vowels.length / text.length.to_f
      percent * @emphasis[:vowels]
    end

    # weight the consonants on a text
    #
    # @param text String
    # @return Float
    def consonants(text)
      percent = text.consonants.length / text.length.to_f
      percent * @emphasis[:consonants]
    end
  end
end