require 'bundler'
Bundler.require :default

require_relative 'config/application'

# Require all application files
Dir["./models/*.rb"].sort.each     { |rb| require rb }
Dir["./helpers/*.rb"].sort.each    { |rb| require rb }

class App < Hobbit::Base
  include Hobbit::Render
  include Hobbit::Helpers::LoadData
  include Hobbit::Helpers::View

  use Rack::Static, root: 'public', urls: ['/css','/fonts','/js','/images']

  get '/' do
    @inserts_data = "[" + File.read("insert_time.json").gsub("\n","") + "]"
    @finds_extension_data = "[" + File.read("find_by_extension_time.json").gsub("\n","") + "]"
    @finds_name_data = "[" + File.read("find_by_name_time.json").gsub("\n","") + "]"
    @finds_size_data = "[" + File.read("find_by_size_time.json").gsub("\n","") + "]"
    
    render 'index'
  end

  get '/load_data' do
    render 'load_data'
  end

  post '/load_data' do
    total = total_storage.to_f
    giga_total = (total/1024).round
    @find_intervals = {"1.0":(giga_total < 1.0), "2.5":(giga_total < 2.5), "5.0":(giga_total < 5.0), "10.0":(giga_total < 10.0), "20.0":(giga_total < 20.0)}

    path = request.params["path"]
    if File.directory?(path)
      files = list_files(path)
      list_names, list_extensions = [], []
      storage, process_files = 0.0, 0
      begin
        files.each do |path_filename|
          puts "Archivo: #{path_filename}"
          archive = Archive.new(path_filename).save
          process_files += 1
          storage += (archive.length / 1_048_576.0)

          if storage >= 450.0
            log_stadistics('insert_time.json',get_last_query_time)
            giga_total = (total_storage.to_f / 1024)
            key_position = @find_intervals.keys.map(&:to_s).map(&:to_f).select{|x| giga_total > x }.last.to_s.to_sym
            if @find_intervals[key_position]
              finds(list_extensions.sample,list_names.sample,rand(2..15_999_999))
              @find_intervals[key_position] = false
            end
            storage = 0.0
          end
          if process_files % 20
            list_names << archive.name
            list_extensions << archive.extension
          end
        end
        @flash = {message: "#{files.count} archivos se han cargado correctamente.", type: "success"}
      rescue
        @flash = {message: "#{process_files} archivos se han cargado correctamente.", type: "success"}
      end
    else
      @flash = {message: "El path no corresponde a un directorio válido", type: "danger"}
    end
    render 'load_data'
  end

end