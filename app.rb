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
    @finds_data = DB.collection('find_stadistics').find().sort( { storage_megabytes: 1 } ).map{|f| {x: f["storage_megabytes"], y:f["find_time"] } }
    @inserts_data = DB.collection('insertion_stadistics').find().sort( { storage_megabytes: 1 } ).map{|f| {x: f["storage_megabytes"], y:f["insert_time"] } }
    render 'index'
  end

  get '/load_data' do
    render 'load_data'
  end

  post '/load_data' do
    path = request.params["path"]
    if File.directory?(path)
      files = list_files(path)
      process_files = 0
      begin
        files.each do |path_filename|
          puts "Archivo: #{path_filename}"
          #guardo el archivo y tiempo de insercion
          archivo = Archive.new(path_filename).save
          save_last_insertion_stadistics(get_last_query_time)
          
          puts "Busco archivo: #{archivo.name}"
          #recupero el archivo para guardar el tiempo de busqueda
          archive = Archive.find(archivo.name)
          save_last_find_stadistics(get_last_query_time)

          puts "Se guardo #{archive.ok?}"
          process_files += 1
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