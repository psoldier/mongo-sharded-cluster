require 'bundler'
Bundler.require :default

# Load
require_relative 'config/application'
require_relative 'models/archive'

class App < Hobbit::Base
  include Hobbit::Mote
  use Rack::Static, root: 'public', urls: ['/css','/fonts','/js']

  get '/' do
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
      Archive.find(archivo.name)
      save_last_find_stadistics(get_last_query_time)
    end
=end
  end

end