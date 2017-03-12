require 'mongo'
@database_ip = '192.168.58.50'
@database_name = 'tesina'
@collection_name = 'archivos'
client = Mongo::Client.new([ @database_ip ], database: @database_name, connect: :sharded)
db = client.database
collection = db.collection(@collection_name)
archivo = collection.find( { name: 'REGLAMENTO TESIS' } ).first

IO.binwrite("aux_#{archivo[:filename]}", archivo[:data].data)

db_file = "aux_#{archivo[:filename]}".gsub(/ /, '\ ')
fs_file = "#{archivo[:full_path]}".gsub(/ /, '\ ')

puts "LOS ARCHIVOS SON EXACTAMENTE IGUALES" if `diff #{db_file} #{fs_file}`.empty?

=begin
 * Para ejecutar usar la consola
 * ~$ ruby diff.rb
 */
=end