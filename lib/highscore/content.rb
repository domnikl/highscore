$:.unshift(File.join(File.dirname(__FILE__)))
require 'keywords'

module Highscore
  class Content
    attr_reader :content

    def initialize(content, blacklist = nil)
      @content = content

      unless blacklist
        blacklist = Highscore::Blacklist.load_default_file
      end

      @blacklist = blacklist

      @emphasis = {
        :multiplier => 1.0,
        :upper_case => 3.0,
        :long_words => 2.0,
        :long_words_threshold => 15,
        :vowels => 0,
        :consonants => 0
      }
    end

    # configure ranking
    #
    def configure(&block)
      instance_eval(&block)
    end

    # set emphasis options to rank the content
    #
    def set(key, value)
      @emphasis[key.to_sym] = value.to_f
    end

    # get the ranked keywords
    #
    # :call-seq:
    #   keywords -> Keywords
    #
    def keywords
      keywords = Keywords.new

      Keywords.find_keywords(@content, @blacklist).each do |text|
        text = text.to_s
        keywords << Highscore::Keyword.new(text, weight(text))
      end

      keywords
    end

    private

    # weight a single text keyword
    #
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

    def vowels(text)
      percent = text.vowels.length / text.length.to_f
      percent * @emphasis[:vowels]
    end

    def consonants(text)
      percent = text.consonants.length / text.length.to_f
      percent * @emphasis[:consonants]
    end
  end
end