#!/usr/local/bin/ruby
require 'set'
require 'sqlite3'

def create_db_schema(name)
  db = SQLite3::Database.new name
  db.execute <<-SQL
     CREATE TABLE documents (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(30));
  SQL

  db.execute <<-SQL
     CREATE TABLE words (id  INTEGER PRIMARY KEY AUTOINCREMENT, doc_id int, value varchar(30));
  SQL

  db.execute <<-SQL
    CREATE TABLE characters (id int, word_id int, value CHARACTER(1));
  SQL
end

def load_file_into_database(path_to_file, db)
  words = File.open(path_to_file).read.gsub(/[\W_]+/," ").downcase.split
  stop_words = Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))

  db.execute "INSERT INTO documents (name) VALUES (?)", path_to_file

  doc_id = db.execute( "SELECT id from documents WHERE name=?" ,path_to_file)[0][0]
  word_id  = db.execute( "SELECT MAX(id) FROM words" )[0][0] || 1

  #
  words = File.open(path_to_file).read.gsub(/[\W_]+/," ").downcase.split
  stop_words= Set.new(File.open("../stop_words.txt").read.split(",")).merge( Set.new( ('a' .. 'z').to_a ))
  words.each do |word|
    unless stop_words.include? word
      db.execute "INSERT INTO words (doc_id,value) VALUES (?, ?)", [doc_id, word]
      char_id = 0
      word.each_char do |c|
        db.execute("INSERT INTO characters VALUES (?, ?, ?)", [char_id, word_id, c])
        char_id += 1
      end
      word_id += 1
    end

  end

end

unless File.file?("tf.db")
  create_db_schema("tf.db")
end

db = SQLite3::Database.new "tf.db"
load_file_into_database(ARGV[0], db)
rows = db.execute("SELECT value, COUNT(*) as C FROM words GROUP BY value ORDER BY C DESC limit 25")
rows.each do |word,count|
  puts "#{word} - #{count}"
end
