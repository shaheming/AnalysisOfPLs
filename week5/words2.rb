module  Word
  puts "load #{__FILE__}"
  def extract_words(path_to_file)
    words=File.open(path_to_file).read.downcase.gsub(/[\W_]+/," ").downcase.split("\s")
    stop_words_set = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
    words.select{|w| !stop_words_set.include? w}
  end
end