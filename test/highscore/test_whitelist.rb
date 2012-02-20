$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "whitelist"
require "test/unit"

class TestBlacklist < Test::Unit::TestCase
  def test_is_wordlist
    whitelist = Highscore::Whitelist.new
    assert whitelist.kind_of? Highscore::Wordlist
  end

  def test_whitelist_content
    whitelist = Highscore::Whitelist.load %w{foo bar}

    content = Highscore::Content.new "foo baz bar", whitelist
    assert_equal 2, content.keywords.length
  end
end