$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "content"
require "blacklist"
require "whitelist"
require "test/unit"
require 'rubygems'

class TestMultipleBlacklists < Test::Unit::TestCase
  def setup
    @nonsense = "Oui monsieur, je suis un programmer. You OK?"
    
    @blacklist_francais = Highscore::Blacklist.load %w{oui je un}
    @blacklist_default = Highscore::Blacklist.load %w{ok you programmer}
    @whitelist_simple  = Highscore::Whitelist.load %{programmer}
    
    @content = Highscore::Content.new @nonsense, @blacklist_default
    @content.configure do
      set :ignore_case, true
    end
    @content.add_wordlist @blacklist_francais, "fr"
    @content.add_wordlist @whitelist_simple, "si"
  end
  
  def test_different_language
    assert (@content.keywords(lang: :fr).top(3).join " ") == 'monsieur programmer suis'
  end
  
  def test_bad_wordlist
    assert_raise ArgumentError do
      @content.add_wordlist 3.14159, "pi"
    end
  end
  
  def test_normal_operation
    assert (@content.keywords.top(3).join " ") == "monsieur oui suis"
  end
  
  def test_added_whitelist
    assert (@content.keywords(lang: :si).top(3).join " ") == "programmer"
  end
end
  
  