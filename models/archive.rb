=begin
  Archive Structure
  {
    filename, 
    name, 
    extension, 
    mime_type, 
    length(in bytes), 
    full_path, 
    data(binary),
    xxhash,
    upload_date 
  }
=end

class Archive
  attr_accessor :_id, :filename, :name, :extension, :mime_type, :length, :full_path, :data, :xxhash, :upload_date

  def initialize(path_filename=nil)
    unless !path_filename
      @filename = File.basename(path_filename)
      @name = File.basename(path_filename, ".*")
      @extension = File.extname(path_filename).delete(".")
      @mime_type = MimeMagic.by_path(path_filename).type
      @length = File.size(path_filename)
      @full_path = File.expand_path(path_filename)
      @data = BSON::Binary.new(IO.binread(path_filename), :md5)
      @upload_date = Time.now
      @xxhash = XXhash.xxh64(IO.binread(path_filename)).to_s
    end
  end

  def save
    DB.collection('archivos').insert_one({
      filename: filename, 
      name: name, 
      extension: extension, 
      mime_type: mime_type, 
      length: length, 
      full_path: full_path, 
      data: data,
      upload_date: Time.now,
      xxhash: xxhash
    })
    last_insert_time = (`tail -n 1 mongo.log`).split("|").last.strip.gsub("s","").to_f
    DB.collection('insertion_stadistics').insert_one({
      insert_time: last_insert_time,
      storage_bytes: DB.command({collStats:'archivos'}).documents.first["storageSize"]
    })
  end

  def self.find name
    begin
      archive = self.new
      DB.collection('archivos').find( { name: name } ).first.each do |key,value|
        archive.send("#{key}=", value)
      end
      last_find_time = (`tail -n 1 mongo.log`).split("|").last.strip.gsub("s","").to_f
      DB.collection('find_stadistics').insert_one({
        insert_time: last_find_time,
        storage_bytes: DB.command({collStats:'archivos'}).documents.first["storageSize"]
      })
      archive
    rescue NoMethodError
      nil
    end
  end

  def ok?
    xxhash.to_i == XXhash.xxh64(data.data)
  end
end