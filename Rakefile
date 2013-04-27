require 'rubygems'
require 'rake/testtask'

task :default => 'test'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "highscore"

gem_name = "highscore-#{Highscore::VERSION}.gem"

namespace :gem do
    desc "clean previously generated gems"
    task :clean do
      system "rm -f *.gem"
    end
    
    desc "build gem"
    task :build => [:clean, :test] do
      system "gem build highscore.gemspec"
    end

    desc "install gem"
    task :install => :build do
      system "gem install #{gem_name}"
    end

    desc "release to rubygems.org"
    task :release => :build do
      system "gem push #{gem_name}"
    end
end

Rake::TestTask.new do |t|
  t.libs = ["lib"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/**/test_*.rb']
end