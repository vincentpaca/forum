require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'json'
require 'mongoid'

Mongoid.load!('./config/database.yml')

require_relative 'routes'
require_relative 'models'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure :test do
  end

  configure :production do
  end

  use Routes
end
