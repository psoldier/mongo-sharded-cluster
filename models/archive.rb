=begin
  Archive Structure
  {
    filename, 
    name, 
    extension, 
    mime_type, 
    length(in bytes), 
    data(binary),
    xxhash,
    upload_date 
  }
=end

class Archive
  attr_accessor :_id, :filename, :name, :extension, :mime_type, :length, :data, :xxhash, :upload_date

  def initialize(path_filename="")
    unless !File.file?(path_filename)
      @filename = File.basename(path_filename)
      @name = File.basename(path_filename, ".*")
      @extension = File.extname(path_filename).delete(".")
      @mime_type = MimeMagic.by_path(path_filename)&.type || ""
      @length = File.size(path_filename)
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
      data: data,
      upload_date: Time.now,
      xxhash: xxhash
    })
    return self
  end

  def self.find name
    begin
      archive = self.new
      DB.collection('archivos').find( { name: name } ).first.each do |key,value|
        archive.send("#{key}=", value)
      end
      archive
    rescue NoMethodError
      nil
    end
  end

  def ok?
    xxhash.to_i == XXhash.xxh64(data.data)
  end
end