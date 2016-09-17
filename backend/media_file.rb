# encoding: utf-8
require 'sinatra'
require 'thin'

set :root, "#{settings.root}/.."
set :server, 'thin'
set :bind, '0.0.0.0'

get /(.*)/ do
  path = params['captures'].first
  erb :video, :locals => { :path => path }
end
