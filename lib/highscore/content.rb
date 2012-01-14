$:.unshift(File.join(File.dirname(__FILE__)))
require 'keywords'

module Highscore
  class Content
      attr_reader :content

    def initialize content
      @content = content
    end

    # get the ranked keywords
    #
    # :call-seq:
    #   keywords -> Keywords
    #
    def keywords
      keywords = Keywords.new(0)

      find_keywords.each do |k|
        keywords[k] += 1
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