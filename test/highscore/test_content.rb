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

  def test_multiple_keywords
    content = 'Ruby Ruby Ruby and so forth ...'

    content = Highscore::Content.new content
    assert_equal 2, content.keywords.length
  end

  # https://github.com/domnikl/highscore/issues/7
  def test_keywords_fixnum
    content = '522 abc 232'

    content = Highscore::Content.new content
    assert_equal 1, content.keywords.length
  end

  def test_vowels_and_consonants
    keywords = 'foobar RubyGems'.keywords do
      set :vowels, 2
      set :consonants, 3
      set :upper_case, 1
      set :long_words, 1
    end

    assert_equal 3.75, keywords.first.weight
    assert_equal 3.5, keywords.last.weight
  end

  def test_rank_short_words
    keywords = 'be as is foobar'.keywords do
      set :ignore_short_words, false
    end

    assert_equal 4, keywords.length
  end

  def test_word_pattern
    keywords = 'foo Ruby foo Ruby'.keywords do
      set :word_pattern, /(?=(\b\w+\s\w+\b))/
    end
    
    assert_equal 2, keywords.length
  end

  def test_ignore_case
    keywords = 'foo Foo bar Bar'.keywords do
      set :ignore_case, true
    end

    assert_equal 2, keywords.length
  end

  def test_stemming
    keywords = 'word words boards board woerter wort'.keywords do
      set :stemming, true
    end

    assert_equal 4, keywords.length
    assert_equal ['board', 'word', 'woerter', 'wort'], keywords.rank.map {|x| x.text }
  end
end