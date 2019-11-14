#!/usr/local/bin/ruby
require 'set'

if ARGV.length != 1
  puts "Please input file name"
  exit
end

if ! File.file?(ARGV[0])
  puts "File not exist"
  exit
end
file = open("../stop_words.txt")
content = file.read
stopWordsSet = Set.new(content.split(","))

book = open(ARGV[0]){|f| f.read}

book = book.downcase.gsub(/'s/, ' ')
book = book.gsub(/[^a-z0-9\s]/i,' ')

words  = book.split("\s")
dic = Hash.new(0)
words.each do |word|
 if !stopWordsSet.include?(word)
    dic[word]+=1
 end
end

frenq = dic.sort_by{|word,fren| -fren}

index = 0
result = []
while index < 25
line =  "#{frenq[index][0]}  -  #{ frenq[index][1] }" 
puts line
index+=1
result.push(line)
end



File.open('output.txt', 'w') { |file| file.write(result.join("\n")) }