highscore
===========

Find and rank keywords in long texts.

Features
--------

* configureable to rank different types of words different (uppercase, long words, etc.)

Examples
--------

    text = Highscore::Content.new "foo bar"
    text.configure.do 
      set :multiplier, 2
      set :upper_case, 3
      set :long_words, 2
      set :long_words_threshold, 15
    end

    # get all keywords
    text.keywords.rank => Array

    # get the top 50 keywords
    text.keywords.top(50).each do |keyword|
      keyword.text   # => keyword text
      keyword.weight # => rank weight (float)
    end


Using a custom blacklist to ignore keywords
-------------------------------------------

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


Requirements
------------

(none)

Install
-------

* sudo gem install highscore

Author
------

Original author: Dominik Liebler <liebler.dominik@googlemail.com>

License
-------

(The MIT License)

Copyright (c) 2012 Dominik Liebler

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
