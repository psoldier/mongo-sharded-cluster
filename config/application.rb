@database_ip = '192.168.58.50'
@database_name = 'tesina'
@collection_name = 'archivos'
client = Mongo::Client.new([ @database_ip ], database: @database_name, connect: :sharded)

DB = client.database