#return all files minor than 16MB
def list_files(dir)
  Dir[ File.join(dir, '**', '*') ].select { |f| File.file?(f) && (File.size(f) / 1_000_000) <= 16 }
end

def get_last_query_time
  (`tail -n 1 mongo.log`).split("|").last.strip.gsub("s","").to_f
end

def save_last_insertion_stadistics last_insert_time
  DB.collection('insertion_stadistics').insert_one({
    insert_time: last_insert_time,
    storage_bytes: DB.command({collStats:'archivos'}).documents.first["storageSize"]
  })
end

def save_last_find_stadistics last_find_time
  DB.collection('find_stadistics').insert_one({
    find_time: last_find_time,
    storage_bytes: DB.command({collStats:'archivos'}).documents.first["storageSize"]
  })
end