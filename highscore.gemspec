# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "highscore"
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dominik Liebler"]
  s.date = "2012-12-13"
  s.description = ""
  s.email = "liebler.dominik@googlemail.com"
  s.executables = ["highscore"]
  s.extra_rdoc_files = ["History.txt", "lib/blacklist.txt"]
  s.files = [".gitignore", ".travis.yml", "lib/blacklist.txt", "lib/highscore.rb", "lib/highscore/blacklist.rb", "lib/highscore/content.rb", "lib/highscore/keyword.rb", "lib/highscore/keywords.rb", "lib/highscore/string.rb", "lib/highscore/whitelist.rb", "lib/highscore/wordlist.rb", "test/fixtures/blacklist.txt", "test/highscore/test_blacklist.rb", "test/highscore/test_content.rb", "test/highscore/test_keyword.rb", "test/highscore/test_keywords.rb", "test/highscore/test_string.rb", "test/highscore/test_whitelist.rb", "test/highscore/test_wordlist.rb", "test/test_highscore.rb", "version.txt"]
  s.files = Dir.glob("{bin,lib,test}/**/*") + %w(README.md History.txt Rakefile version.txt)
  s.homepage = "https://domnikl.github.com/highscore"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "highscore"
  s.rubygems_version = "1.8.16"
  s.summary = ""
  s.test_files = Dir.glob('test/**/*')
  s.description = "Find and rank keywords in text."
  s.summary = "Easily find and rank keywords in long texts."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<simplecov>, [">= 0.6.4"])
    else
      s.add_dependency(%q<simplecov>, [">= 0.6.4"])
    end
  else
    s.add_dependency(%q<simplecov>, [">= 0.6.4"])
  end
end
