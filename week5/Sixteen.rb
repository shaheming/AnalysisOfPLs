#!/usr/local/bin/ruby
require 'set'


#stack check is here
def getStopWordsSet(path)
  unless caller[0].include? "frequencies"
    return
  end
  Set.new(open(path){|f| f.read}.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
end

def frequencies(words)
  stop_words_set = getStopWordsSet("../stop_words.txt")
  dict = Hash.new(0)
  words.each do |word|
    dict[word]+=1  unless stop_words_set.include?(word)
  end
  dict
end

eval %q(def filterCharsAndNormalize(content) content.downcase.gsub(/[\W_]+/," ") end)

eval %q(def scan(content) content.split("\s")  end)

eval "def getText(path) File.open(path).read end"

eval "def sortFreq(wordsFreq) wordsFreq.sort_by{|word,freq| -freq} end"

eval 'def printAll(freqs) freqs.each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }" }  end'




freq = send(:frequencies,send(:scan,send(:filterCharsAndNormalize,send(:getText,ARGV[0]))))

str = send(:sortFreq,freq)[0..24]

send(:printAll,str)

