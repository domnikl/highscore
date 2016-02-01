$:.unshift(File.join(File.dirname(__FILE__), %w{.. lib highscore}))

begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  # ignore ...
end

require 'highscore'
require 'minitest/autorun'

module Highscore
  class TestCase < Minitest::Test
    def test_version
      assert (not Highscore::VERSION.nil?)
    end
  end
end
