# frozen_string_literal: true

require 'sinatra'
require 'socket'
require 'launchy'
require './src/file_helper'
require './src/disk_helper'

disk_helper = DiskHelper.new
disk_helper.change_disk 1

ENV['STATIC_FILE_PORT'] ||= settings.port.to_s
ENV['MEDIA_FILE_PORT'] ||= settings.port.to_s

set :public_folder, disk_helper.current_disk
set :server, 'puma'
set :bind, '0.0.0.0'

get '/favicon.ico' do
  204
end

get(/(.*)/) do
  path = params['captures'].first
  path += '/' if path[-1] != '/'
  no_back = (path == '/')
  dir = settings.public_folder + CGI.unescape(path)
  begin
    files = FileHelper.get_file_list dir
  rescue StandardError
    files = []
  end
  erb :index, locals: { path: path,
                        files: files,
                        disk: disk_helper,
                        no_back: no_back }
end

post '/chdisk' do
  disk = params['disk'].to_i
  disk_helper.change_disk disk
  settings.public_folder = disk_helper.current_disk
  redirect '/'
end

post '/move' do
  file = params['file']
  folder = params['folder']
  path = settings.public_folder + params['path']
  begin
    FileUtils.move File.join(path, file), File.join(path, folder, file)
  rescue StandardError => e
    result = e.message + "\n"
    result += e.backtrace.join("\n")
    puts result
    redirect back
  end
  redirect File.join(params['path'], folder)
end

post '/upload' do
  redirect back if params['file'].nil?
  path = File.join(settings.public_folder, params['path'])
  file_name = params['file'][:filename]
  file_name = 'uploaded_' + file_name if File.exist? File.join(path, file_name)
  File.open(File.join(path, file_name), 'wb') do |f|
    f.write(params['file'][:tempfile].read)
  end
  redirect back
end

post '/mkdir' do
  dir_name = params['name']
  path = settings.public_folder + params['path']
  is_exist = Dir.exist? File.join(path, dir_name)
  has_illegal_name = dir_name =~ %r{\x00/\\:\*\?\"<>\|}
  redirect back if is_exist || has_illegal_name
  FileUtils.mkdir File.join(path, dir_name)
  redirect back
end

Socket.ip_address_list.detect do |intf|
  next unless intf.ipv4_private?

  ip = intf.ip_address.to_s
  url = "http://#{ip}:#{settings.port}/"
  Launchy.open(url)
end
