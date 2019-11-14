#!/usr/local/bin/ruby
require 'set'


def read_file(path)
  File.open(path).read
end

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

def count_words(mapping)
  [mapping[0],mapping[1].map{|map| map[1]}.reduce(:+)]
end

def sort(word_freq)
  word_freq.sort_by{|word,freq| -freq}
end


def regroup(pairs_list)
  mapping = {}
  pairs_list.each do |pairs|
    pairs.each  do |pair|
     ( mapping[pair[0]] ||= []) << pair
    end
  end
  mapping
end

splits = partition(read_file(ARGV[0]),200).map{|text| split_words(text)}
splits_per_word = regroup(splits)
word_freqs = sort(splits_per_word.to_a.map {|split| count_words(split)})
word_freqs[0..24].each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }"}