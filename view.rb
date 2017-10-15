require 'sinatra'
require 'sinatra/reloader'
require_relative 'db.rb'

get '/' do
@urls=Url.all
erb :index
end
