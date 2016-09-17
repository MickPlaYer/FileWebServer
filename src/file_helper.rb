require 'zip'
zip_file_generator_rb = File.join Gem::bin_path('rubyzip', ''), '../samples', 'example_recursive.rb'
require zip_file_generator_rb

class FileHelper
  def self.get_file_list path
    file_list = []
    Dir.entries(path, encoding: "UTF-8").each do |e|
      next if e == '.' or e == '..'
      file_list << get_file_detail(path + e)
    end
    file_list.sort_by! { |e| e["dir"] ? 0 : 1 }
    return file_list
  end

  def self.get_file_detail filename
    file = { }
    file["name"] = File.basename(filename)
    file["time"] = File.mtime(filename)
    file["dir"] = File.directory?(filename)
    file["size"] = file["dir"] ? -1 : File.size(filename)
    return file
  end

  def self.generator_zip_file input_dir, output_file
    zfg = ZipFileGenerator.new input_dir, output_file
    zfg.write
    zfg = nil
    GC.start
  end

  def self.format_size size
    return '' if size == -1
    unit = ["KB", "MB", "GB", "TB"]
    i = 0
    j = 1
    size /= 1024.0
    while size > 1024
      break if i >= 3
      i += 1
      j = 2
      size /= 1024.0
    end
    return "%.#{j}f" % size + ' ' + unit[i]
  end
end
