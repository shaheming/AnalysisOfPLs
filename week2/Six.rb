#!/usr/local/bin/ruby
require 'set'

stops = open("../stop_words.txt").read.split(",").to_set
words = open(ARGV[0]).read.downcase.gsub!(/'s/, ' ').gsub!(/[^a-z0-9\s]/i,' ').split("\s").select { |word| !stops.include? word }
freqs = words.group_by(&:itself).transform_values(&:count).sort_by {|word,freq| -freq}
freqs[0..24].each {|freq| puts "#{freq[0]}  -  #{freq[1]}"}