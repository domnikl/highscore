$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "blacklist"
require "test/unit"

class TestBlacklist < Test::Unit::TestCase
  def test_is_a_wordlist
    blacklist = Highscore::Blacklist.new
    assert blacklist.kind_of? Highscore::Wordlist
  end

  def test_load_default_file
    blacklist = Highscore::Blacklist.load_default_file
    assert_equal 42, blacklist.length
  end

  def test_blacklisting_content
      keywords = "Foo bar is not bar baz".keywords(Highscore::Blacklist.load(%w(baz)))

      keyword_list = []
      keywords.rank.each do |k|
        keyword_list << k.text
      end

      expected_keywords = %w(Foo bar not)

      assert_equal expected_keywords, keyword_list
  end
end