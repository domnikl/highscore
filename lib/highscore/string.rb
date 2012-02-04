# monkey patch to define a keywords method on arbitrary strings
#
class String

  # get keywords from the string
  #
  def keywords(blacklist = nil, &block)
    content = Highscore::Content.new(self, blacklist)

    if block_given?
      content.configure do
        content.instance_eval(&block)
      end
    end

    content.keywords
  end
end