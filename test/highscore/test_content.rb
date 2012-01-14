$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "content"
require "test/unit"

class TestContent < Test::Unit::TestCase
  def setup
    @text = "This is some text"
    @content = Highscore::Content.new(@text)
  end

  def test_content
    assert_equal @text, @content.content
  end

  def test_keywords
    assert_instance_of(Highscore::Keywords, @content.keywords)
  end
end