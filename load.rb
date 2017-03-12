=begin
  FILE Structure
  {
    filename, 
    name, 
    extension, 
    mime_type, 
    length(in bytes), 
    full_path, 
    data(binary),
    upload_date 
  }
  ######################################################################################
  1)Install Ruby
    ~$  sudo apt-get update
    ~$  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs
  2)Install libmagic-dev
    ~$  sudo apt-get install libmagic-dev
  3)Install gems
    ~$  gem install ruby-filemagic
    ~$  gem install mongo
  4)Run console ruby
    ~$ irb
=end

require 'mongo'
require 'filemagic'

@folder_path = '/home/psoldier/Documentos'
@file_size_allowed = 8 #MB

@database_ip = '192.168.58.50'
@database_name = 'tesina'
@collection_name = 'archivos'

def generate_file_data(path_filename)
  puts "PROCESA: #{path_filename}"
  filename = File.basename(path_filename)
  name = File.basename(path_filename, ".*")
  extension = File.extname(path_filename).delete(".")
  mime_type = FileMagic.new(FileMagic::MAGIC_MIME).file(path_filename)
  length = File.size(path_filename)
  full_path = File.expand_path(path_filename)
  data = BSON::Binary.new(IO.binread(path_filename), :md5)
  upload_date = Time.now
  {
    filename: filename, 
    name: name, 
    extension: extension, 
    mime_type: mime_type, 
    length: length, 
    full_path: full_path, 
    data: data,
    upload_date: Time.now 
  }
end

def list_files(dir)
  Dir[ File.join(dir, '**', '*') ].reject { |p| File.directory? p }
end

client = Mongo::Client.new([ @database_ip ], database: @database_name, connect: :sharded)
db = client.database
collection = db.collection(@collection_name)
list_files(@folder_path).each do |filename|
  next if filename == '.' or filename == '..'
  #Guardo el archivo si es menor igual a 8MB
  if (File.size(filename) / 1_000_000) <= @file_size_allowed
    collection.insert_one(generate_file_data(filename))
  else
    puts "NO PROCESA: #{filename}. TAMAÑO: #{(File.size(filename) / 1_000_000)}MB"
  end
end

=begin
 * Para ejecutar usar la consola
 * ~$ ruby script.rb
 */
=end