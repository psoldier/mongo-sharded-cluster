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

end