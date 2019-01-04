# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './src/disk_helper'
require './helpers/app_helper'

set :root, "#{__dir__}/.."
set :erb, { layout: false }
set :bind, '0.0.0.0'
set :disk_helper, DiskHelper.new

helpers AppHelper

get(/(.*)/) do
  path = params['captures'].first
  erb :video, locals: { path: path }
end
