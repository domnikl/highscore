$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "content"
require "blacklist"
require "whitelist"

class TestMultipleBlacklists < Highscore::TestCase
  def setup
    @nonsense = "Oui monsieur, je suis un programmer. You OK?"
    
    @blacklist_francais = Highscore::Blacklist.load %w{oui je un}
    @blacklist_default = Highscore::Blacklist.load %w{ok you programmer}
    @whitelist_simple  = Highscore::Whitelist.load %{programmer}
    
    @content = Highscore::Content.new @nonsense, @blacklist_default
    @content.configure do
      set :ignore_case, true
    end
    @content.add_wordlist @blacklist_francais, 'fr'
    @content.add_wordlist @whitelist_simple, 'si'
  end
  
  def sort_for_ruby18(keywords)
    keywords.join(' ').split(' ').sort
  end
  
  def test_different_language
    assert_equal %w(monsieur programmer suis you), sort_for_ruby18(@content.keywords(:lang => :fr).top(4))
  end
  
  def test_bad_wordlist
    assert_raises ArgumentError do
      @content.add_wordlist 3.14159, "pi"
    end
  end
  
  def test_normal_operation
    assert_equal %w(monsieur oui suis), sort_for_ruby18(@content.keywords.top(3))
  end
  
  def test_added_whitelist
    assert_equal %w(programmer), sort_for_ruby18(@content.keywords(:lang => :si).top(3))
  end
end
  
  