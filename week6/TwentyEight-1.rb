#!/usr/local/bin/ruby
require 'set'
# thr = Thread.new { puts "Whats the big deal" }
# thr.join #=> "Whats the big deal"

class Actor < Thread
  def initialize
    super(&method(:__run))
    @queue = Queue.new
    @stop_me = false
  end
  def __run
      while  !@stop_me
        message = @queue.pop
        send(:dispatch,message)
        if  message[0] == 'die'
          @stop_me = true
        end
      end

  end

  def queue
    @queue
  end
end

def send_message(receiver,msg)
  receiver.queue.push(msg)
end

class DataStorageManager < Actor
  def dispatch(message)
    if message[0] == 'init'
      send(:init,message[1..-1])
    elsif message[0] == 'send_word_freqs'
      send(:process_words,message[1..-1])
    else
      # forward
      send_message(@word_freqs_manager, message)
    end
  end

  def init(message)
    path_to_file = message[0]
    @word_freqs_manager=message[1]
    @data = File.open(path_to_file).read.downcase.gsub(/[\W_]+/," ").downcase
  end

  def process_words(message)
    recipient = message[0]
    @data.split.each do |w|
      send_message(@word_freqs_manager,['word',w])
    end
    send_message(@word_freqs_manager,['top25',recipient])
  end
end


class WordFrequencyManager < Actor
  # @word_freqs =nil

  def dispatch(message)
    if message[0] == 'init'
      self.init
    elsif message[0] == 'word'
      send(:increment_count,message[1..-1])
    elsif message[0] == 'top25'
      send(:top25,message[1..-1])
    end
  end


  def increment_count(message)
    unless @stop_words_set.include? message[0]
      @word_freqs ||= Hash.new(0)
      @word_freqs[message[0]]+=1
    end
  end

  def top25(message)
    send_message(message[0],['top25',@word_freqs.sort_by{|word,freq| -freq}])
  end

  def init
    @stop_words_set = Set.new(File.open("../stop_words.txt").read.split(","))
    @stop_words_set.merge( Set.new( ('a' .. 'z').to_a ))
  end

  def filter(message)
    unless @stop_words_set.include? message[0]
      send_message(@word_freqs_manager, ['word', message[0]])
    end
  end

end

class WordFrequencyController< Actor
  def dispatch(message)
    if message[0] == 'run'
      send(:_run,message[1..-1])
    elsif message[0] == 'top25'
      send(:display,message[1..-1])
    else
      raise "Message not understood " + message[0].to_s
    end
  end

  def _run(message)
    @storage_manager = message[0]
    send_message(@storage_manager,['send_word_freqs', self])
  end

  def display(message)
    message[0][0..24].each{|freq|  puts "#{freq[0]}  -  #{ freq[1] }"}
    send_message(@storage_manager,['die'])
    @stop_me = true
  end

end



threads = []
word_freq_manager = WordFrequencyManager.new
threads<<word_freq_manager
send_message(word_freq_manager, ['init'])

storage_manager = DataStorageManager.new
send_message(storage_manager, ['init', ARGV[0], word_freq_manager])

threads<<storage_manager
wfcontroller = WordFrequencyController.new
send_message(wfcontroller, ['run', storage_manager])
threads<<wfcontroller


threads.each {|thread|
   thread.join
}
