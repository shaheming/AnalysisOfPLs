#!/usr/local/bin/ruby
require 'set'
require  'benchmark/memory'
require  'benchmark/ips'

#in the all_words(file_path) function
#all_words(file_path).each do |word|
#  func(word)
# end
# will call func when every word generate
# non_stop_words(file_path).each do |w|
#  func2(w)
# end
# will call func2 for every non_stop_words found
# the count_and_sort will generate word freq dictionary and sort it

def get_file(file_path)
  File.open(file_path).each_char.lazy
end

def all_words(file_path)
  Enumerator.new  do |yielder|
    start_char = true
    word = ""
    get_file(file_path).each do |c|
      if start_char
        if c.match(/^[[:alnum:]]+$/)
          word = c.downcase
          start_char = false
        else
          next
        end
      else
        if c.match(/^[[:alnum:]]+$/)
          word += c.downcase
        else
          yielder  << word
          start_char = true
        end
      end
    end
  end
end

def non_stop_words(file_path)
  stop_words = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
  Enumerator.new  do |yielder|
    all_words(file_path).each do |word|
      unless stop_words.include? word
        yielder << word
      end
    end
  end
end



def count_and_sort(file_path)
  freqs,i=Hash.new(0),1
  Enumerator.new  do |yielder|
    non_stop_words(file_path).each do |w|
      freqs[w]+=1
      if i % 5000 == 0
        yielder << freqs.sort_by{|word,freq| -freq}
      end
    end
    yielder << freqs.sort_by{|word,freq| -freq}
  end
end




count_and_sort(ARGV[0]).each do |freq|
  freq[0..24].each do |word,count|
    puts "#{word} - #{count}"
  end
end






# flowing is benchmark

# def lazy_enumerations
#   count_and_sort(ARGV[0]).each do |freq|
#     freq[0..24].each do |word,count|
#       "#{word} - #{count}"
#     end
#   end
# end


#
# def enumerations
#   start_char = true
#   word = ""
#   words = []
#   File.open(ARGV[0]).each_char do |c|
#     if start_char
#       if c.match(/^[[:alnum:]]+$/)
#         word = c.downcase
#         start_char = false
#       else
#         next
#       end
#     else
#       if c.match(/^[[:alnum:]]+$/)
#         word += c.downcase
#       else
#         words  << word
#         start_char = true
#       end
#     end
#   end
#   stop_words = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
#   freqs=Hash.new(0)
#   words.each do |word|
#     unless stop_words.include? word
#       freqs[word]+=1
#     end
#   end
#   r = freqs.sort_by{|word,freq| -freq}
#
#   r[0..24].each do |k,v|
#     "#{k} - #{v}"
#   end
#
# end

# Benchmark.memory do |x|
#
#   x.report("Enumerations") do
#     enumerations
#   end
#
#   x.report("Lazy Enumerations") do
#
#     lazy_enumerations
#   end
#
#   x.compare!
# end
#



# Benchmark.ips do |x|
#   x.config(:time => 5, :warmup => 2)
#
#   x.report("Enumerations") do
#     enumerations
#   end
#
#   x.report("Lazy Enumerations") do
#     lazy_enumerations
#   end
#
#   x.compare!
# end
