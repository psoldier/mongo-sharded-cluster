Mongo::Logger.logger = ::Logger.new('mongo.log')

DB = Mongo::Client.new([ '163.10.33.220' ], database: 'tesina', connect: :sharded).database
SHARD_IPS = ['163.10.33.223','163.10.33.217','163.10.33.224']