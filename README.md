# highscore

Easily find and rank keywords in long texts.

[![Build Status](https://secure.travis-ci.org/domnikl/highscore.png?branch=develop)](http://travis-ci.org/domnikl/highscore) [![Code Climate](https://codeclimate.com/github/domnikl/highscore.png)](https://codeclimate.com/github/domnikl/highscore)

## Features

* configurable to rank different types of words different (uppercase, long words, etc.)
* rate based on amount (%) of vowels and consonants in a string
* directly get keywords from String objects
* blacklist words via a plain text file, String or an Array of words (per language if needed)
* optionally, configure a whitelist and only words from that list will get ranked
* uses word stemming if necessary (requires the `fast-stemmer` or `stemmer` gem)
* merge together Keywords from multiple sources
* contains a CLI tool that operates on STDIN/OUT and is configurable via parameters
* can use `bloomfilter-rb` gem for better performance (optional)
* words on the bonus list will receive a higher score

## Installation

* `[sudo] gem install highscore`

For better blacklist perfomance, use the `bloomfilter-rb` gem:

* `[sudo] gem install bloomfilter-rb`

To use word stemming, you need to have the `fast-stemmer` (C extension) or `stemmer` gem installed:

* `[sudo] gem install fast-stemmer`
* `[sudo] gem install stemmer`

## Examples

```ruby
text = Highscore::Content.new "foo bar"
text.configure do
  set :multiplier, 2
  set :upper_case, 3
  set :long_words, 2
  set :long_words_threshold, 15
  set :short_words_threshold, 3      # => default: 2
  set :bonus_multiplier, 2           # => default: 3
  set :vowels, 1                     # => default: 0 = not considered
  set :consonants, 5                 # => default: 0 = not considered
  set :ignore_case, true             # => default: false
  set :word_pattern, /[\w]+[^\s0-9]/ # => default: /\w+/
  set :stemming, true                # => default: false
end

# get only the top 50 keywords
text.keywords.top(50).each do |keyword|
  keyword.text   # => keyword text
  keyword.weight # => rank weight (float)
end

# you could also just use a string
keywords = "Foo bar baz".keywords(blacklist) do
  set :multiplier, 10
end
```

The result is either a Highscore::Keywords object or an Array (depending on whether it's sorted or not) that you
can iterate over. Each object in there is a Highscore::Keyword that has methods `text` and `weight`.

```ruby
keywords = "Foo bar is not bar baz".keywords(Highscore::Blacklist.load(['baz']))

keywords.rank.each do |k|
  puts "#{k.text} #{k.weight}"
end

# prints:
# Foo 3.0
# bar 2.0
# not 1.0
```

Have a look at `bin/highscore`, you can run highscore on your CLI and feed it with text on STDIN.

## Blacklisting and Whitelisting

### Using a custom blacklist to ignore keywords

```ruby
# setting single words
blacklist = Highscore::Blacklist.new
blacklist << 'foo'

# load a string/array
blacklist = Highscore::Blacklist.load "a string"
blacklist = Highscore::Blacklist.load %w{an array}

# loading from a file (separated by whitespace)
blacklist = Highscore::Blacklist.load_file "blacklist.txt"

# loading the default blacklist (falls back automatically if not explicit given)
blacklist = Highscore::Blacklist.load_default_file

# inject the blacklist into the content class
content = Highscore::Content.new "a string", blacklist
```

### Using a whitelist instead of ranking all words

```ruby
# construct and inject it just like a blacklist
whitelist = Highscore::Whitelist.load %w{these are valid keywords}
content = Highscore::Content.new "invalid words", whitelist
```

### Using bonus words

```ruby
# construct and inject it just like a blacklist
bonuslist = Highscore::Bonuslist.load %w{bonus words}
content = Highscore::Content.new "A string with bonus words in it", bonuslist
```

## I18n

```ruby
# Load a default blacklist
blacklist_default = Highscore::Blacklist.load "mister"
text = Highscore::Content.new "oui mister interesting", blacklist_default
text.keywords.top(3).join " "

# => prints "interesting oui"

# Load a rudimentary blacklist for French
blacklist_francais = Highscore::Blacklist.load "oui"
text.add_wordlist blacklist_francais, :french
text.keywords(:lang => :fr).top(3).join " "

# => prints "interesting mister"
```

## Author

Original author: Dominik Liebler <liebler.dominik@gmail.com>

## License

(The MIT License)

Copyright (c) 2013 Dominik Liebler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
