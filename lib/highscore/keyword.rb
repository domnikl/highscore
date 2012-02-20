module Highscore

  # keywords read from the content
  #
  class Keyword
    attr_accessor :weight, :text

    # init a keyword
    #
    # @param text String
    # @param weight Float
    def initialize(text, weight)
      @text = text
      @weight = weight.to_f
    end

    # sort keywords
    #
    # @param other Highscore::Keyword
    def <=>(other)
      other.weight <=> @weight
    end

    # get the string
    #
    # @return String
    def to_s
      @text
    end
  end
end