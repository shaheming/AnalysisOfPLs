#!/usr/local/bin/ruby
require 'set'

def extract_words(obj,path_to_file)
  File.open(path_to_file){|f|
    obj[:data] = f.read
    obj[:data].gsub!(/[\W_]+/," ").downcase!
    obj[:data] = obj[:data].split
  }
end

def load_stop_words(obj)
  File.open("../stop_words.txt"){|f|
    obj[:stop_words] = Set.new(f.read.split(","))
    obj[:stop_words].merge( Set.new( ('a' .. 'z').to_a ))
  }
end

def increment_count(obj,w)
  obj[:freqs][w] += 1
end
data_storage_obj = {
    :data=>[],
    :init=> ->(path_to_file){extract_words(data_storage_obj,path_to_file)},
    :words=>->(){data_storage_obj[:data]}
}
stop_words_obj = {
    :stop_words=>[],
    :init => ->(){load_stop_words(stop_words_obj)},
    :is_stop_word => ->(word){stop_words_obj[:stop_words].include? word}

}

word_freqs_obj = {
    :freqs=>Hash.new(0),
    :increment_count=> ->(w){increment_count(word_freqs_obj,w)},
    :sort => ->(){word_freqs_obj[:freqs].sort_by{|word,freq| -freq}}

}

data_storage_obj[:init].call(ARGV[0])
stop_words_obj[:init].call

for w in data_storage_obj[:words].call
  unless stop_words_obj[:is_stop_word].(w)
    word_freqs_obj[:increment_count].(w)
  end
end

word_freqs = word_freqs_obj[:sort].()

word_freqs[0..24].each {|w,c|
  puts "#{w} - #{c}"
}