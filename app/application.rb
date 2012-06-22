require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'json'
require 'mongoid'
require 'yaml'
require 'haml'

#load db
Mongoid.load!('./config/database.yml')

#load api keys
FB_APP_ID = YAML::load(File.open('./config/api.yml'))['facebook']['app_id']
FB_SECRET = YAML::load(File.open('./config/api.yml'))['facebook']['secret']
TW_KEY = YAML::load(File.open('./config/api.yml'))['twitter']['key']
TW_SECRET = YAML::load(File.open('./config/api.yml'))['twitter']['secret']
  
#require routes, models and helpers
require_relative './routes/init'
require_relative './models/init'
require_relative './helpers/init'

class Application < Sinatra::Application
  enable :sessions
  set :public_folder, File.dirname(__FILE__) + "/public"
  set :views, File.dirname(__FILE__) + "/views"

  configure :development do
    register Sinatra::Reloader
  end

  configure :test do
  end

  configure :production do
  end
end
