require 'win32ole'

class DiskHelper
  attr_reader :disks, :index

  def initialize
    @disks = []
    file_system = WIN32OLE.new("Scripting.FileSystemObject")
    file_system.Drives.each do |d|
      @disks << d.DriveLetter + ':/'
    end
    @index = 0
  end

  def current_disk
    @disks[@index]
  end

  def change_disk option
    @index = option
  end
end
