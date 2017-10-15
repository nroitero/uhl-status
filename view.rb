require 'sinatra'
require 'sinatra/reloader'
require_relative 'db.rb'
require_relative 'auth.rb'
require 'oauth2'
enable :sessions

# Scopes are space separated strings


get '/' do
  @urls = Url.all
  erb :index
end
get '/admin' do
  @urls = Url.all
  erb :admin
end
post '/admin' do
    db=Url.first_or_create(url: params['url'])
db.save
    @urls = Url.all
    erb :admin
  end
  get '/admin/delete/:id' do
Url.get(params[:id]).destroy
redirect '/admin'
  end
    