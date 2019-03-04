# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'active_support/all'
require 'socket'
require 'launchy'
require './src/file_helper'
require './src/disk_helper'
require './helpers/app_helper'

ENV['STATIC_FILE_PORT'] ||= settings.port.to_s
ENV['MEDIA_FILE_PORT'] ||= settings.port.to_s

set :disk_helper, DiskHelper.new
set :server, 'puma'
set :bind, '0.0.0.0'

helpers AppHelper

get('/favicon.ico') { 204 }

get('/') { erb :disks }

get('/__sinatra__/*path') { redirect static_url request.path }

get(%r{/__file__/?}) { halt 404 }
get('/__file__/:disk*path') do |disk, path|
  disk_helper.change_disk(disk)
  file = disk_helper.current_disk + CGI.unescape(path)
  send_file file
rescue DiskHelper::NoDiskError
  halt 404
end

get('/:disk*path') do |disk, path|
  disk_helper.change_disk(disk)
  path += '/' unless path.end_with?('/')
  dir = disk_helper.current_disk + CGI.unescape(path)
  files = FileHelper.get_file_list(dir)
  erb :index, locals: {
    path: path,
    full_path: disk_helper.path + path,
    files: files
  }
rescue FileHelper::NotDirError
  erb :index_404, locals: {
    path: path,
    full_path: disk_helper.path + path
  }
rescue DiskHelper::NoDiskError
  redirect '/'
end
