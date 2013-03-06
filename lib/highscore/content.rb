$:.unshift(File.dirname(__FILE__))
require 'keywords'

# external gems
require 'rubygems'

module Highscore
  class Content
    attr_reader :content
    attr_accessor :language_wordlists

    # @param content String
    # @param wordlist Highscore::Wordlist
    def initialize(content, wordlist = nil)
      @content = content
      @whitelist = @blacklist = nil
      @language_wordlists = {}

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
        :word_pattern => /\p{Word}+/u,
        :stemming => false
      }
      
      if RUBY_VERSION =~ /^1\.8/
        @emphasis[:word_pattern] = /\w+/
      end
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
    
    # add another wordlist, given a language
    #
    # @param language_wordlist Highscore::Wordlist
    # @param language String
    def add_wordlist(language_wordlist, language)
      raise ArgumentError, "Not a valid Wordlist" unless language_wordlist.kind_of? Highscore::Wordlist
      language_wordlists[language.to_sym] = language_wordlist
    end

    # get the ranked keywords
    #
    # @return Highscore::Keywords
    def keywords(opts = {})
      used_wordlist = nil

      if opts[:lang]
        used_wordlist = language_wordlists[opts[:lang].to_sym]
      else
        used_wordlist = wordlist
      end
        
      @emphasis[:stemming] = use_stemming?

      keywords = Keywords.new
      Keywords.find_keywords(processed_content, used_wordlist, word_pattern).each do |word|
        keyword = extract_keyword(word)
        keywords << keyword unless keyword.nil?
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

    # guess the language of the content and return a symbol for it
    # => done via whatlanguage gem
    #
    # @return Symbol
    def language
      @content.language
    end

    private

    # extracts a single keyword from a single word
    # 
    # @return Highscore::Keyword
    def extract_keyword word
      word = word.to_s
      word = word.stem if @emphasis[:stemming]

      if not (word.match(/^[\d]+(\.[\d]+){0,1}$/) or word.length <= 2)
        Highscore::Keyword.new(word, weight(word))
      elsif allow_short_words
	Highscore::Keyword.new(word, weight(word))
      end
    end

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

    # using stemming is only possible if fast-stemmer is installed
    # doesn't work for JRuby
    def use_stemming?
      if @emphasis[:stemming]
        begin
          require 'fast_stemmer'
          true
        rescue LoadError
          begin
            require 'stemmer'
            true
          rescue LoadError
            false
          end
        end
      else
        false
      end
    end
  end
end
