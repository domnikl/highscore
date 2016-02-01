require File.dirname(__FILE__) + '/../test_highscore'

class TestKeyword < Highscore::TestCase
  def setup
    @keyword = Highscore::Keyword.new('Ruby', 2)
  end

  def test_init

    # don't allow 'empty' keywords
    assert_raises(ArgumentError) do
      Highscore::Keyword.new
    end
  end

  def test_text
    assert_equal 'Ruby', @keyword.text

    @keyword.text = 'Foobar'
    assert_equal 'Foobar', @keyword.text
  end

  def test_to_s
    assert_equal 'Ruby', @keyword.to_s
  end

  def test_weight
    assert_equal 2, @keyword.weight

    @keyword.weight = 10.123
    assert_equal 10.123, @keyword.weight
  end
  
  def test_percent
    # per default, percent is not used => nil
    assert_nil @keyword.percent
    
    @keyword.percent = 50.1
    assert_equal 50.1, @keyword.percent
  end
end