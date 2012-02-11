module Highscore

  # keywords read from the content
  #
  class Keyword
    attr_accessor :weight, :text

    # init a keyword
    def initialize(text, weight)
      @text = text
      @weight = weight.to_f
    end

    # sort keywords
    def <=>(other)
      other.weight <=> @weight
    end

    # get the string
    def to_s
      @text
    end
  end
end