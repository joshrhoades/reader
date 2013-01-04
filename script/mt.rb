require 'feedzirra'

fz = Feedzirra:Feed.fetch_and_parse 'http://blog.instapaper.com/rss'

file = File.open('fz.txt', 'w+:ASCII-8BIT')
file.write fz
file.close


