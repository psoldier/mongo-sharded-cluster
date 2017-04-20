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

      def finds random_extension, random_name, random_length
        DB.collection('archivos').find( { extension: random_extension } ).count
        log_stadistics('find_by_extension_time.json',get_last_query_time)

        archive = Archive.find(random_name)
        raise "Archivo #{archive.filename} mal guardado" unless archive.ok?
        log_stadistics('find_by_name_time.json',get_last_query_time)
        

        DB.collection('archivos').find( { length: {"$gt"=> random_length} } ).count
        log_stadistics('find_by_size_time.json',get_last_query_time)
      end
    end
  end
end