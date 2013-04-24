# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "highscore"
  s.version = File.read('version.txt').chomp

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dominik Liebler"]
  s.date = "2012-12-13"
  s.description = ""
  s.email = "liebler.dominik@googlemail.com"
  s.executables = ["highscore"]
  s.extra_rdoc_files = ["History.txt", "lib/blacklist.txt"]
  s.files = Dir.glob("{bin,lib,test}/**/*") + %w(README.md History.txt Rakefile version.txt)
  s.homepage = "http://domnikl.github.com/highscore"
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
      s.add_development_dependency('simplecov', [">= 0.6.4"])
      s.add_dependency('whatlanguage', ['>=1.0.0'])
    else
      s.add_dependency('simplecov', [">= 0.6.4"])
      s.add_dependency('whatlanguage', ['>=1.0.0'])
      s.add_dependency('bloomfilter-rb', ['>=2.1.1'])
    end
  else
    s.add_dependency('simplecov', [">= 0.6.4"])
    s.add_dependency('whatlanguage', ['>=1.0.0'])
  end
end
