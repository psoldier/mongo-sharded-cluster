Mongo::Logger.logger = ::Logger.new('mongo.log')

DB = Mongo::Client.new([ '163.10.33.228' ], database: 'tesina').database