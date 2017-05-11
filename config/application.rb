Mongo::Logger.logger = ::Logger.new('mongo.log')

DB = Mongo::Client.new([ '163.10.33.224:27017, 163.10.33.225:27017, 163.10.33.227:27017' ], database: 'tesina', replica_set: 'rs').database