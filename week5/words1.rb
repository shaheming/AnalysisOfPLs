module  Word
  puts "load #{__FILE__}"
  def extract_words(path_to_file)
    File.open(path_to_file){|f|
      content = f.read
      words = content.downcase.gsub(/[\W_]+/," ").downcase.split("\s")
      stop_words_set = Set.new(File.open("../stop_words.txt").read.split(","))
      stop_words_set.merge( Set.new( ('a' .. 'z').to_a ))
      words.select{|w| !stop_words_set.include? w}
    }
  end
end