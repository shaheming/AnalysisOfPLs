#!/usr/local/bin/ruby
require 'set'


all_words = [[] , nil]

stop_words = [[], nil]

non_stop_words = [[], ->() {
  all_words[0].select{|w| !stop_words[0].include? w}
}]


unique_words = [Set.new([]),->(){
  Set.new(non_stop_words[0])
}]

counts= [[],->{unique_words[0].map{|w|  non_stop_words[0].count(w) } }]

sorted_data = [[],->{unique_words[0].zip(counts[0]).sort_by{|k,v|-v}}]

$all_columns = [all_words, stop_words, non_stop_words,
                unique_words, counts, sorted_data]

def update
  $all_columns.each {
      |column| column[0] = column[1].() unless column[1].nil?
  }
end

all_words[0] = File.open(ARGV[0]).read.gsub(/[\W_]+/," ").downcase.split

stop_words[0] = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))


update

sorted_data[1].()[0..24].each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }"}