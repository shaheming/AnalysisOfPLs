#!/usr/local/bin/ruby
require 'set'
require 'yaml'

# configuration = { :words => "words1.rb" ,
#                   :freq => "frequencies1.rb",
#                 }
# open('config.yaml', 'w') { |f| YAML.dump(configuration, f) }
config = YAML.load_file('config.yaml')


load(config[:words])
load(config[:freq])
include Word
include Freq
freqs = Freq.top25(Word.extract_words(ARGV[0]))
freqs.each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }"}