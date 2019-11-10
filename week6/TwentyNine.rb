#!/usr/local/bin/ruby
require 'set'
# thr = Thread.new { puts "Whats the big deal" }
# thr.join #=> "Whats the big deal"


$word_space  = Queue.new
$freq_space  = Queue.new
$stop_words_set = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))



def process_words
  word_freqs = Hash.new(0)
  while true
    begin
      word = $word_space.pop(true)
    rescue ThreadError =>e
      break
    end

    unless $stop_words_set.include? word
      word_freqs[word]+=1
    end
  end
  unless word_freqs.empty?
    $freq_space.push(word_freqs)
  end
  # puts word_freqs
end

File.open(ARGV[0]).read.downcase.gsub(/[\W_]+/," ").downcase.split.each{|w|
  $word_space.push w
}

workers = []
5.times{|_|
  workers<< Thread.new(&method(:process_words))
}


workers.each { |work|
  work.join
}
$word_freqs = Hash.new 0

until $freq_space.empty?
  freqs = $freq_space.pop
  freqs.each do |k,v|
    $word_freqs[k]+=v
  end
end

$word_freqs.sort_by{|word,freq| -freq}[0..24].each do  |freq|
  puts "#{freq[0]}  -  #{ freq[1] }"
end
