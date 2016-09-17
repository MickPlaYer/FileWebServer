# encoding: utf-8
require 'sinatra'
require 'thin'

set :root, "#{settings.root}/.."
set :server, 'thin'
set :bind, '0.0.0.0'
