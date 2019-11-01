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


data_storage_obj = Hash.new.yield_self {|this|
  this.merge!({  :data=>[],
                   :init=> ->(path_to_file){extract_words(this,path_to_file)},
                   :words=>->(){this[:data]}
              })

}

stop_words_obj =  Hash.new.yield_self {|this|
  this.merge! ({
      :stop_words=>[],
      :init => ->(){load_stop_words(this)},
      :is_stop_word => ->(word){
        this[:stop_words].include? word
      }
  })
}

word_freqs_obj = Hash.new.yield_self {
  |this|
  this.merge!(
  {
      :freqs=>Hash.new(0),
      :increment_count=> ->(w){increment_count(this,w)},
      :sort => ->(){this[:freqs].sort_by{|word,freq| -freq}}
  }
  )
}

data_storage_obj[:init].call(ARGV[0])
stop_words_obj[:init].call

for w in data_storage_obj[:words].call
  unless stop_words_obj[:is_stop_word].(w)
    word_freqs_obj[:increment_count].(w)
  end
end


word_freqs_obj.yield_self{|this|
  this[:top25] = ->(){
    this[:sort].()[0..24].each {|w,c|
      puts "#{w} - #{c}"
    }
  }
}

word_freqs_obj[:top25].()
