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

get('/__file__/:disk*path') do |disk, path|
  disk_helper.change_disk(disk)
  file = disk_helper.current_disk + CGI.unescape(path)
  send_file file
end

get('/:disk*path') do |disk, path|
  disk_helper.change_disk(disk)
  path += '/' unless path.end_with?('/')
  dir = disk_helper.current_disk + CGI.unescape(path)
  puts disk, path
  puts dir
  begin
    files = FileHelper.get_file_list(dir)
  rescue StandardError
    files = []
  end
  erb :index, locals: {
    path: path,
    full_path: disk_helper.path + path,
    files: files
  }
end

