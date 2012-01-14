$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "keywords"
require "test/unit"

class TestKeywords < Test::Unit::TestCase
  def setup
    @keywords = Highscore::Keywords.new
    @keywords['Ruby'] = 2
    @keywords['Sinatra'] = 3
    @keywords['Highscore'] = 1
    @keywords['the'] = 10
  end

  def test_init
    assert Highscore::Keywords.new.length == 0
  end

  def test_rank
    assert @keywords.length == 4

    ranked = @keywords.rank

    assert_instance_of(Array, ranked)

    should_rank = [['Sinatra', 3], ['Ruby', 2], ['Highscore', 1]]
    assert_equal should_rank, ranked
  end

  def test_rank_empty
    assert_equal [], Highscore::Keywords.new.rank
  end

  def test_top
    assert_equal [['Sinatra', 3]], @keywords.top(1)
  end

  def test_top_empty
    assert_equal [], Highscore::Keywords.new.top(0)
  end

  def test_sort
    keywords = Highscore::Keywords.new
    keywords['Test'] = 1
    keywords['Foobar'] = 2

    assert_equal [['Foobar', 2], ['Test', 1]], keywords.sort_it
  end
end