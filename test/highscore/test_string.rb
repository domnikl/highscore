require File.dirname(__FILE__) + '/../test_highscore'

class TestString < Highscore::TestCase
  def setup
    blacklist_file = File.join(File.dirname(__FILE__), %w{.. fixtures blacklist.txt})
    @blacklist = Highscore::Blacklist.load_file(blacklist_file)
  end

  def test_init
    keywords = "".keywords
    assert_equal 0, keywords.length
  end

  def test_vowels
    assert_equal("eoaiu", "feobariu".vowels)
  end

  def test_consonants
    assert_equal("fbr", "feobariu".consonants)
  end

  def test_default_blacklist
    keywords = "the Ruby Ruby Ruby Hacker".keywords
    assert_equal 2, keywords.length
  end

  def test_custom_blacklist
    keywords = "this is the test Ruby Ruby Ruby Hacker".keywords(@blacklist)

    assert_equal 2, keywords.length

    assert_equal 9, keywords.first.weight
    assert_equal 3, keywords.last.weight
  end

  def test_with_block
    keywords = "this is the test Ruby Ruby Ruby Hacker".keywords(@blacklist) do
      set :multiplier, 10
    end

    assert_equal 90, keywords.first.weight
    assert_equal 30, keywords.last.weight
  end

  def test_short?
    assert "to".short?
    assert (not "this ain't no short word".short?)
  end
end
