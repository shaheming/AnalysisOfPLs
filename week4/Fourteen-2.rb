#!/usr/bin/ruby2.5
require 'set'

class WordFrequencyFramework

  def initialize
    @load_event_handlers = []
    @dowork_event_handlers = []
    @end_event_handlers = []
  end
  def register_for_load_event(handler)
    @load_event_handlers.append(handler)
  end

  def register_for_dowork_event( handler)
    @dowork_event_handlers.append(handler)
  end

  def register_for_end_event( handler)
    @end_event_handlers.append(handler)
  end
  def run( path_to_file)
    @load_event_handlers.each{|handler|   handler[0].send(handler[1],path_to_file) }
    @dowork_event_handlers.each{|handler|  handler[0].send(handler[1])  }
    @end_event_handlers.each{|handler| handler[0].send(handler[1]) }
 end
end
class DataStorage
  def initialize(wfapp, stop_word_filter)
    @data = ''
    @word_event_handlers = []
    @stop_word_filter = stop_word_filter
    wfapp.register_for_load_event([self,:__load])
    wfapp.register_for_dowork_event([self,:__produce_words])
  end

  def __load(path_to_file)
    File.open(path_to_file){|f|
      @data= f.read.gsub!(/[\W_]+/," ").downcase!
    }
  end
  def __produce_words
    data_str = @data
    data_str.split.each do |word|
      unless @stop_word_filter.is_stop_word word
        @word_event_handlers.each do |handler|
          handler[0].send(handler[1],word)
        end
      end
    end

end
  def register_for_word_event(handler)
    @word_event_handlers.append(handler)
  end
end

class StopWordFilter
  @stop_words = nil
  def initialize(wfapp)
    wfapp.register_for_load_event([self,:__load])
  end

  def __load(null)
    File.open("../stop_words.txt"){|f|
      @stop_words = Set.new(f.read.split(","))
      @stop_words.merge( Set.new( ('a' .. 'z').to_a ))
    }
  end

  def is_stop_word(word)
    @stop_words.include?(word)
  end
end

class WordFrequencyCounter

  def initialize(wfapp,data_storage)
    @word_freqs = Hash.new(0)
    data_storage.register_for_word_event([self,:__increment_count])
    wfapp.register_for_end_event([self,:__print_freqs])
  end
  def __increment_count(word)
    @word_freqs[word] += 1
  end

  def __print_freqs
    @word_freqs.sort_by{|word,freq| -freq}[0..24].each {|w,c|
      puts "#{w} - #{c}"
    }
    # counter = 0
    # @word_freqs.each {|k,v| counter+= v if k.include? "z"}
    # puts"z #{counter}"
  end
end

class WordWithZCounter
  def initialize(wfapp,data_storage)
    @word_with_z_count = 0
    data_storage.register_for_word_event([self,:__increment_count])
    wfapp.register_for_end_event([self,:__print_z_count])
  end
  def __increment_count(word)
    if word.include? 'z'
      @word_with_z_count +=1
    end
  end

  def __print_z_count
      puts "\nWords with count: #{@word_with_z_count}\n"
  end
end
wfapp = WordFrequencyFramework.new()
stop_word_filter = StopWordFilter.new(wfapp)
data_storage = DataStorage.new(wfapp, stop_word_filter)
word_freq_counter = WordFrequencyCounter.new(wfapp, data_storage)
word_with_z_count = WordWithZCounter.new(wfapp,data_storage)
wfapp.run(ARGV[0])