require 'mongo'
require 'xxhash'

@database_ip = '192.168.58.50'
@database_name = 'tesina'
@collection_name = 'archivos'
client = Mongo::Client.new([ @database_ip ], database: @database_name, connect: :sharded)
db = client.database
collection = db.collection(@collection_name)
archivo = collection.find( { name: 'load' } ).first

puts "LOS ARCHIVOS SON EXACTAMENTE IGUALES" if archivo[:xxhash].to_i == XXhash.xxh64(archivo[:data].data)

=begin
 * Para ejecutar usar la consola
 * ~$ ruby diff.rb
 */
=end