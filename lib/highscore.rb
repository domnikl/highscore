module Highscore
  # :stopdoc:
  LIBPATH = ::File.expand_path('..', __FILE__) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  VERSION = ::File.read(PATH + 'version.txt').strip
  # :startdoc:

  def self.load_modules
    modules = %w(
      blacklist
      content
      keyword
      keywords
      string
      whitelist
      wordlist
      bonuslist
    )
    
    modules.each do |m|
      require ::File.expand_path('highscore/' + m, LIBPATH)
    end
  end
end

Highscore.load_modules
