module Hobbit
  module Helpers
    module LoadData

      def list_files(dir)
        Dir[ File.join(dir, '**', '*') ].select { |f| File.file?(f) && (File.size(f) / 1_048_576.0) <= 16.0 }
      end

      #time in Miliseconds
      def get_last_query_time
        ((`tail -n 1 mongo.log`).split("|").last.strip.gsub("s","").to_f * 1000.0).to_i
      end

      def log_stadistics filename, time
        File.open(filename, 'a'){ |f| f.puts "{'x': #{total_storage}, 'y': #{time}},"}
      end

      #storageSize in MB
      def total_storage
        (DB.command({collStats:'archivos'}).documents.first["storageSize"] / 1_048_576.0).round
      end

      def extra_sharding_stadistics
        if defined? SHARD_IPS
          #Conenxion random a un shard
          dbaux = Mongo::Client.new([SHARD_IPS.sample], database: 'tesina', connect: :direct)

          #guardo todos los ids de un shard en el file
          filename = 'coleccion_de_ids.txt'
          File.open(filename, 'a') do |f|
            dbaux.database.collection('archivos').find().limit(20).each do |archivo|
              f.puts(archivo["_id"].to_s)
            end
          end

          #cierro conexion al shard
          dbaux.close

          #hago la query para recuperar todos los elementos de un shard
          contents = File.open(filename, "rb").readlines.map(&:chomp)
          DB.collection('archivos').find('_id': {'$in': contents.collect{|x|BSON::ObjectId.from_string(x)} }).count
          log_stadistics('find_by_shard_time.json',get_last_query_time)

          #borro el file para futuras ejecuciones
          File.delete(filename)
        end 
      end

      def finds random_extension, random_name, random_length
        DB.collection('archivos').find( { extension: random_extension } ).count
        log_stadistics('find_by_extension_time.json',get_last_query_time)

        archive = Archive.find(random_name)
        raise "Archivo #{archive.filename} mal guardado" unless archive.ok?
        log_stadistics('find_by_name_time.json',get_last_query_time)

        DB.collection('archivos').find( { length: {"$gt"=> random_length} } ).count
        log_stadistics('find_by_size_time.json',get_last_query_time)

        extra_sharding_stadistics
      end
    end
  end
end