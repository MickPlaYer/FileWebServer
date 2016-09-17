# encoding: utf-8
require 'sinatra'
require 'thin'
require './src/file_helper'
require './src/disk_helper'

disk_helper = DiskHelper.new
disk_helper.change_disk 1

set :public_folder, disk_helper.current_disk
set :server, 'thin'
set :bind, '0.0.0.0'

get '/favicon.ico' do
  204
end

get /(.*)/ do
  path = params['captures'].first
  no_back = (path == '/')
  dir = settings.public_folder + path
  redirect path + '/' unless path =~ /\/$/
  begin
    files = FileHelper.get_file_list dir
  rescue
    files = []
  end
  erb :index, locals: { path: path, files: files, disk: disk_helper, no_back: no_back }
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
  origin = FileUtils.pwd
  begin
    FileUtils.cd path
    FileUtils.move file, path + folder + file
  rescue Exception => e
    result = e.message + "\n"
    result += e.backtrace.join("\n")
    puts result
  ensure
    FileUtils.cd origin
  end
  redirect back
end

post '/zip' do
  path = settings.public_folder + params['path']
  folder = params['folder']
  out_file = Time.now.to_i.to_s + '_' + folder + '.zip'
  FileHelper.generator_zip_file path + folder, out_file
  FileUtils.move out_file, './public/' + out_file
  redirect 'http://' + request.host + ':3031/' + out_file
end
