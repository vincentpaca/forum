require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'json'
require 'mongoid'
require 'yaml'

#load db
Mongoid.load!('./config/database.yml')

#load api keys
FB_APP_ID = YAML::load(File.open('./config/api.yml'))['facebook']['app_id']
FB_SECRET = YAML::load(File.open('./config/api.yml'))['facebook']['secret']
TW_KEY = YAML::load(File.open('./config/api.yml'))['twitter']['key']
TW_SECRET = YAML::load(File.open('./config/api.yml'))['twitter']['secret']

  
#require models
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
