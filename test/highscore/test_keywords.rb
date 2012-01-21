$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require 'keywords'
require 'keyword'
require "test/unit"

class TestKeywords < Test::Unit::TestCase
  def setup
    @keywords = Highscore::Keywords.new
    @keywords << Highscore::Keyword.new('Ruby', 2)
    @keywords << Highscore::Keyword.new('Sinatra', 3)
    @keywords << Highscore::Keyword.new('Highscore', 1)
    @keywords << Highscore::Keyword.new('the', 10)
  end

  def test_init
    assert Highscore::Keywords.new.length == 0
  end

  def test_rank
    assert @keywords.length == 4

    ranked = @keywords.rank

    ranked_texts = []
    ranked.each do |keyword|
      assert(keyword.instance_of?(Highscore::Keyword),
             "keywords must be instances of Highscore::Keyword, #{keyword.class} given")
      ranked_texts << keyword.text
    end

    should_rank = %w{the Sinatra Ruby Highscore}

    assert_equal should_rank, ranked_texts
  end

  def test_rank_empty
    assert_equal [], Highscore::Keywords.new.rank
  end

  def test_top
    top = @keywords.top(1)

    assert_equal('the', top[0].text)
    assert_equal(10.0, top[0].weight)
  end

  def test_top_empty
    assert_equal [], Highscore::Keywords.new.top(0)
  end
end