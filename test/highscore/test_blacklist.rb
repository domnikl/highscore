$:.unshift(File.join(File.dirname(__FILE__), %w{.. .. lib highscore}))
require "blacklist"
require "test/unit"

class TestBlacklist < Test::Unit::TestCase
  def test_load_default_file
    blacklist = Highscore::Blacklist.load_default_file
    assert_equal 42, blacklist.length
  end
end