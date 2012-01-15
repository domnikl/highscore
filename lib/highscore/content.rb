$:.unshift(File.join(File.dirname(__FILE__)))
require 'keywords'

module Highscore
  class Content
    attr_reader :content

    def initialize content
      @content = content

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
      keywords = Keywords.new(0)

      find_keywords.each do |k|
        weight = @emphasis[:multiplier]

        if k.length >= @emphasis[:long_words_threshold]
          weight *= @emphasis[:long_words]
        end

        if k[0] == k[0].upcase
          weight *= @emphasis[:upper_case]
        end

        keywords[k] += weight
      end

      keywords
    end

    private

    # find keywords in the content and rate them
    #
    def find_keywords
      keywords = @content.scan(/\w+/)
      keywords.delete_if do |x|
        x.match(/^[\d]+(\.[\d]+){0,1}$/) or x.length <= 2
      end

      keywords.sort
    end
  end
end