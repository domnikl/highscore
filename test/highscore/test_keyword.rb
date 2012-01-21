$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require 'keyword'
require "test/unit"

class TestKeyword < Test::Unit::TestCase
  def setup
    @keyword = Highscore::Keyword.new('Ruby', 2)
  end

  def test_init

    # don't allow 'empty' keywords
    assert_raise(ArgumentError) do
      Highscore::Keyword.new
    end
  end

  def test_text
    assert_equal 'Ruby', @keyword.text

    @keyword.text = 'Foobar'
    assert_equal 'Foobar', @keyword.text
  end

  def test_weight
    assert_equal 2, @keyword.weight

    @keyword.weight = 10.123
    assert_equal 10.123, @keyword.weight
  end
end