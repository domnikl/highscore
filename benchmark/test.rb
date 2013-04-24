require 'bloomfilter-rb'

wordlist = %w(foo bar baz this is an even longer text uns so weiter lsdflksdflk sdkdk dkdkd k kd dksdfk)
is = %w(foo is no good far away)

n = wordlist.length # number of filter elements
b = 4  # bits per bucket
m = n * b * 10 # number of filter buckets
k = (0.7 * (m / n)).to_i # number of hash functions

k = 2 if k <= 1

bf = BloomFilter::Native.new(:size => m, :bucket => b, :raise => true, :hashes => k)
wordlist.each { |w| bf.insert(w) }



is.each do |i|
  puts "#{i} is in wordlist (#{wordlist.join(', ')}): #{bf.include?(i)}"
end




bf.stats