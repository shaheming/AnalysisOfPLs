#!/usr/local/bin/ruby
require 'set'

def read_file(path_to_file, func)
  data = File.open(path_to_file).read
  send(func,data, :normalize)
end

def filter_chars(str_data, func)
  send(func,str_data.gsub(/[\W_]+/," "),:scan)
end
def normalize(str_data, func)
  send(func,str_data.downcase, :remove_stop_words)
end

def scan(str_data, func)
  send(func, str_data.split, :frequencies)
end
def remove_stop_words(word_list, func)
  stop_words = File.open("../stop_words.txt").read.split(',')
  s = Set.new(stop_words)
  s.merge( Set.new( ('a' .. 'z').to_a ))
  send(func,word_list.select{|word| !s.include? word }, :sort)
end

def frequencies(word_list, func)
  wf = Hash.new(0)
  word_list.each do |word|
    wf[word]+=1
  end
  send(func,wf, :print_text)
end
def sort(wf, func)
  send(func,wf.sort_by{|word,freq| -freq}, :no_op)
end

def print_text(word_freqs, func)
  word_freqs[0..24].each {|w,c|
    puts "#{w} - #{c}"
  }
  send(func,:no_op)
end

def no_op(func)
end



read_file(ARGV[0], :filter_chars)
