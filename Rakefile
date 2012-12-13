require 'rubygems'

task :default => 'test:run'
task 'gem:release' => 'test:run'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "highscore"

gem_name = "highscore-#{Highscore::VERSION}.gem"

namespace :gem do
    task :build do
      system "gem build highscore.gemspec"
    end

    task :install => :build do
      system "gem install #{gem_name}"
    end

    task :release => :build do
      system "gem push #{gem_name}"
    end
end