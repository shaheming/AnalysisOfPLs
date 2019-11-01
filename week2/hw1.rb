#!/usr/local/bin/ruby
require 'set'


#!/usr/local/bin/ruby
require 'set'


def getFilePath(argv)
  if argv.length != 1
    puts "Please input file name"
    exit
  end
  argv[0]
end

def assertFileExist(path)
  unless File.file?(path)
    puts "File not exist"
    exit
  end
  path
end


def getStopWordsSet(path)
  content = open(path){|f| f.read}
  Set.new(content.split(","))
end


def filterCharsAndNormalize(content)
  content.downcase.gsub(/'s/, ' ').gsub(/[^a-z0-9\s]/i,' ')
end

def scan(content)
  content.split("\s")
end

def frequencies(path)
  assertFileExist(path)
  dict = Hash.new(0)
  File.open(path) do |f|

    words = scan(filterCharsAndNormalize(f.read))
    stopWordsSet=getStopWordsSet("../stop_words.txt")

    words.each do |word|
      if !stopWordsSet.include?(word)
        dict[word]+=1
      end


    end
  end
  dict
end
def sort(wordsFreq)
  wordsFreq.sort_by{|word,freq| -freq}
end


def printAll(wordsFreq)
  wordsFreq.each{|freq|
    puts "#{freq[0]}  -  #{ freq[1] }"

  }
end


printAll(sort(frequencies(getFilePath(ARGV)))[0..24])
