require 'rubygems'
require 'bundler'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

Bundler.require

require './app/application.rb'

run Application
