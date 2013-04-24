$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

content_file = File.join(File.dirname(__FILE__), 'benchmark.txt')
blacklist = File.join(File.dirname(__FILE__), 'blacklist.txt')

require 'benchmark'
require 'highscore'

Benchmark.bm(10) do |x|
  blacklist = Highscore::Blacklist.load_file(blacklist)
  content = Highscore::Content.new(File.read(content_file), blacklist)
  content.configure do
    set :ignore_case, true
  end
    
  puts content.keywords.length
    
  x.report("1000x Top 50") do
    1.upto(1000) do
      content.keywords.top(50)
    end
  end
end


# ORIGINAL (!)
#                  user     system      total        real
# 1000x Top 50   132.240000   0.350000 132.590000 (135.016700)

# WITHOUT vocals and consonants
#                  user     system      total        real
# 1000x Top 50    69.360000   0.210000  69.570000 ( 73.501761)

# WITHOUT hashing the key
#                  user     system      total        real
# 1000x Top 50    53.690000   0.120000  53.810000 ( 55.365629)

# USING a bloom filter
#                 user     system      total        real
# 1000x Top 50 46.550000   0.140000  46.690000 ( 47.569285)