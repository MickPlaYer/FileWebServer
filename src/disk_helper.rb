require 'win32ole'

class DiskHelper
  NoDiskError = Class.new(StandardError)
  attr_reader :disks, :index

  def initialize
    @disks = []
    file_system = WIN32OLE.new('Scripting.FileSystemObject')
    file_system.Drives.each do |d|
      @disks << d.DriveLetter
    end
    @index = 0
  end

  def current_disk
    raise NoDiskError if @index.nil? || @disks[@index].nil?

    "#{@disks[@index]}:/"
  end

  def path
    "/#{@disks[@index].to_s.downcase}"
  end

  def change_disk(option)
    case option
    when Integer
      @index = option
    when String
      @index = @disks.index(option.upcase)
    end
  end
end
