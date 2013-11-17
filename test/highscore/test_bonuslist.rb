require File.dirname(__FILE__) + '/../test_highscore'

class TestBonuslist < Highscore::TestCase
  def test_is_wordlist
    bonuslist = Highscore::Bonuslist.new
    assert bonuslist.kind_of? Highscore::Bonuslist
  end

  def test_bonus_content
    bonuslist = Highscore::Bonuslist.load %w{Hacker}

    text = Highscore::Content.new "Cats Cats Cats Cats Ruby Hacker", bonuslist

    results = text.keywords.rank

    assert_equal results[0].text, "Cats"
    assert_equal results[1].text, "Hacker"
    assert_equal results[2].text, "Ruby"

    assert_equal results[0].weight, 12.0
    assert_equal results[1].weight, 6.0
    assert_equal results[2].weight, 3.0
  end

  def test_repeated_word
    bonuslist = Highscore::Bonuslist.load %w{Hacker}

    text = Highscore::Content.new "Cats Hacker Cats Cats Ruby Hacker", bonuslist

    results = text.keywords.rank

    assert_equal results[0].text, "Hacker"
    assert_equal results[1].text, "Cats"
    assert_equal results[2].text, "Ruby"

    assert_equal results[0].weight, 12.0
    assert_equal results[1].weight, 9.0
    assert_equal results[2].weight, 3.0
  end

  def test_bonus_option

    bonuslist = Highscore::Bonuslist.load %w{Hacker}

    text = Highscore::Content.new "Cats Hacker Cats Cats Ruby Hacker", bonuslist

    text.configure do
      set :bonus_multiplier, 4
    end

    results = text.keywords.rank

    assert_equal results[0].text, "Hacker"
    assert_equal results[1].text, "Cats"
    assert_equal results[2].text, "Ruby"

    assert_equal results[0].weight, 14.0
    assert_equal results[1].weight, 9.0
    assert_equal results[2].weight, 3.0
  end
end