require File.expand_path("../config/environment", __FILE__)


fz = Feedzirra::Feed.fetch_and_parse 'http://blog.instapaper.com/rss'

file = File.open('fz.txt', 'w+:ASCII-8BIT')
file.write Marshal.dump fz
file.close

file2 = File.open('fz.txt','r')
fz2 = Marshal.load file2

puts fz2.inspect
