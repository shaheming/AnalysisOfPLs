module Freq
  puts "load #{__FILE__}"
  def top25(word_list)
    dict = Hash.new(0)
    word_list.each do |word|
      dict[word]+=1
    end
    dict.sort_by{|word,freq| -freq}[0..24]
  end
end