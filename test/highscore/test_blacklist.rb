$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "blacklist"
require "test/unit"

class TestBlacklist < Test::Unit::TestCase
  def test_load_file
    file_path = File.join(File.dirname(__FILE__), %w{.. fixtures blacklist.txt})
    blacklist = Highscore::Blacklist.load_file(file_path)

    assert_equal 6, blacklist.length
  end

  def test_load_default_file
    blacklist = Highscore::Blacklist.load_default_file
    assert_equal 42, blacklist.length
  end

  def test_load_file_fail
    assert_raises(Errno::ENOENT) do
      Highscore::Blacklist.load_file('foobar')
    end
  end

  def test_empty_blacklist
    blacklist = Highscore::Blacklist.new
    assert_equal 0, blacklist.length
  end

  def test_add_new_word
    blacklist = Highscore::Blacklist.new
    blacklist << 'foo'

    assert_equal ['foo'], blacklist.words
  end

  def test_load_string_and_remove_special_chars
    blacklist = Highscore::Blacklist.load "this is an awesome string!"
    assert_equal 5, blacklist.length

    assert_equal ['this', 'is', 'an', 'awesome', 'string'], blacklist.to_a
  end

  def test_load_array
    words = ['foo', 'bar', 'baz']

    blacklist = Highscore::Blacklist.load(words)

    assert_equal words, blacklist.words
  end

  def test_load_unknown_type
    assert_raises ArgumentError do
      Highscore::Blacklist.load(1)
    end
  end

  def test_include?
    blacklist = Highscore::Blacklist.load "foobar baz"

    assert blacklist.include?("foobar")
    assert !blacklist.include?("bla")
  end

  def test_blacklisting_content
    keywords = "Foo bar is not bar baz".keywords(Highscore::Blacklist.load(['baz']))

    keyword_list = []
    keywords.rank.each do |k|
      keyword_list << k.text
    end

    expected_keywords = ['Foo', 'bar', 'not']

    assert_equal expected_keywords, keyword_list
  end
end