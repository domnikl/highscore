$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "wordlist"
require "test/unit"

class TestBlacklist < Test::Unit::TestCase

  def test_load_file
    file_path = File.join(File.dirname(__FILE__), %w{.. fixtures blacklist.txt})
    blacklist = Highscore::Wordlist.load_file(file_path)

    assert_equal 6, blacklist.length
  end

  def test_load_file_fail
    assert_raises(Errno::ENOENT) do
      Highscore::Blacklist.load_file('foobar')
    end
  end

  def test_empty_blacklist
    blacklist = Highscore::Wordlist.new
    assert_equal 0, blacklist.length
  end

  def test_add_new_word
    blacklist = Highscore::Wordlist.new
    blacklist << 'foo'

    assert_equal %w(foo), blacklist.words
  end

  def test_load_string_and_remove_special_chars
    blacklist = Highscore::Wordlist.load "this is an awesome string!"
    assert_equal 5, blacklist.length

    assert_equal %w{this is an awesome string}, blacklist.to_a
  end

  def test_load_array
    words = %w{foo bar baz}

    blacklist = Highscore::Wordlist.load(words)

    assert_equal words, blacklist.words
  end

  def test_load_unknown_type
    assert_raises ArgumentError do
      Highscore::Wordlist.load(1)
    end
  end

  def test_include?
    blacklist = Highscore::Wordlist.load "foobar baz"

    assert blacklist.include?("foobar")
    assert !blacklist.include?("bla")
  end
end