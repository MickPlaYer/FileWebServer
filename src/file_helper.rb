# frozen_string_literal: true

class FileHelper # :nodoc:
  UNIT = %w[KB MB GB TB]
  def self.get_file_list(path)
    file_list = []
    Dir.entries(path, encoding: 'UTF-8').each do |e|
      next if (e == '.') || (e == '..')

      file_list << get_file_detail(path + e)
    end
    file_list.sort_by! { |e| e['dir'] ? 0 : 1 }
    file_list
  end

  def self.get_file_detail(filename)
    file = {}
    file['name'] = File.basename(filename)
    file['time'] = File.mtime(filename)
    file['dir'] = File.directory?(filename)
    file['size'] = file['dir'] ? -1 : File.size(filename)
    file
  end

  def self.format_size(size)
    return '' if size == -1

    i = 0
    j = 1
    while (size /= 1024.0) > 1024
      break if i >= 3

      i += 1
      j = 2
    end
    format("%.#{j}f", size) + ' ' + UNIT[i]
  end
end
