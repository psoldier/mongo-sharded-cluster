require 'bundler'
Bundler.require :default

# Load
require_relative 'config/application'
require_relative 'models/archive'

class App < Hobbit::Base
  include Hobbit::Render
  use Rack::Static, root: 'public', urls: ['/css','/fonts','/js','/images']

  get '/' do
    @pablo = "pabloKpo"
    @inserts_data = [{ x: 1, y: 2.1 }, { x: 3.3, y: 3.9 }, { x: 5.2, y: 7.1 }]
    @finds_data = [{ x: 2, y: 0 }, { x: 3, y: 2 }, { x: 5, y: 10 }]
    render 'index'
  end

  post '/' do
=begin
    path = params[:path]
    list_files(path).each do |path_filename|
      #guardo el archivo
      archivo = Archive.new(path_filename).save
      save_last_insertion_stadistics(get_last_query_time)
      #recupero el archivo
      archive = Archive.find(archivo.name)
      save_last_find_stadistics(get_last_query_time)
      #check same file saved
      raise "Archivo mal guardado" unless archive.ok?
    end
=end
  end

end