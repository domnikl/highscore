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
        :long_words_threshold => 15
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
        weight = @emphasis[:multiplier]
        text = text.to_s

        if text.length >= @emphasis[:long_words_threshold]
          weight *= @emphasis[:long_words]
        end

        if text[0] == text[0].upcase
          weight *= @emphasis[:upper_case]
        end

        keywords << Highscore::Keyword.new(text, weight)
      end

      keywords
    end
  end
end