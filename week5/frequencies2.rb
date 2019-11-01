module Freq
  puts "load #{__FILE__}"
  class Counter < Hash
    def initialize(a=[])
      super
      self.default=0
      a.each{|e|self[e]+=1}
    end
    def self.[](*a)
      new(a)
    end
    def most_common(n)
      self.sort_by{|word,freq| -freq}[0..n-1]
    end
  end

  def top25(word_list)
    counts = Counter.new word_list
    counts.most_common 25
  end
end