#!/usr/local/bin/ruby
require 'set'




def split_words(str)
  def _scan(str)
    str.gsub(/[\W_]+/," ").downcase.split
  end
  def _remove_stop_words(words)
    stop_words_set = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
    words.select{|word| not stop_words_set.include?(word) }
  end
  words = _remove_stop_words(_scan(str))
  words.map{|word| [word,1]}
end

def partition(str,n)
  lines = str.split("\n")
  (0..lines.size-1).step(n).to_a.map do |i|
     lines[i..i+n-1].join("\n")
  end
end

def count_words(pairs_list_1, pairs_list_2)
  mapping = Hash.new(0)
  pairs_list_1.each do |k,v|
    mapping[k]+=v
  end
  pairs_list_2.each do |k,v|
    mapping[k]+=v
  end
  mapping.to_a
end

def sort(word_freq)
  word_freq.sort_by{|word,freq| -freq}
end

def read_file(path)
  File.open(path).read
end

splits = partition(read_file(ARGV[0]),200).map{|text| split_words(text)}

word_freqs = sort(splits.inject {|memo, values| count_words(memo, values)})
word_freqs[0..24].each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }"}