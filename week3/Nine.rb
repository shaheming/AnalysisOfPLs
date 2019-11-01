#!/usr/local/bin/ruby
require 'set'

class TFTheOne
  def initialize(v)
    @_value = v
  end
  def bind( func)
    @_value = send func, @_value
    self
  end
  def printme
    puts @_value
  end
end


def read_file(path_to_file)
  File.open(path_to_file).read
end

def filter_chars(str_data)
  str_data.gsub(/[\W_]+/," ")
end
def normalize(str_data)
  str_data.downcase
end

def scan(str_data)
  str_data.split
end
def remove_stop_words(word_list)
  stop_words = File.open("../stop_words.txt").read.split(',')
  s = Set.new(stop_words)
  s.merge( Set.new( ('a' .. 'z').to_a ))
  word_list.select{|word| !s.include? word }
end

def frequencies(word_list)
  wf = Hash.new(0)
  word_list.each do |word|
    wf[word]+=1
  end
  wf
end
def sort(wf)
  wf.sort_by{|word,freq| -freq}
end

def print_text(word_freqs)
  word_freqs[0..24].each {|w,c|
    puts "#{w} - #{c}"
  }
end

def top25_freqs(word_freqs)
  word_freqs[0..24].map{|k,v| "#{k} - #{v}"}.join "\n"
end

TFTheOne.new(ARGV[0])\
.bind(:read_file)\
.bind(:filter_chars)\
.bind(:normalize)\
.bind(:scan)\
.bind(:remove_stop_words)\
.bind(:frequencies)\
.bind(:sort)\
.bind(:top25_freqs)\
.printme()