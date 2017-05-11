require 'pathname'
require Pathname.new(__FILE__).dirname.join('app.rb').realpath.to_path

run App.new