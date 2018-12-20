# frozen_string_literal: true

require 'sinatra'

set :root, "#{settings.root}/.."
set :bind, '0.0.0.0'

get(/(.*)/) do
  path = params['captures'].first
  erb :video, locals: { path: path }
end
