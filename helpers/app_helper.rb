module AppHelper
  def app_url(path)
    "#{request.scheme}://#{request.host}#{path}"
  end

  def static_url(path)
    "#{request.scheme}://#{request.host}:#{ENV['STATIC_FILE_PORT']}#{path}"
  end

  def media_url(path)
    "#{request.scheme}://#{request.host}:#{ENV['MEDIA_FILE_PORT']}#{path}"
  end

  def disk_helper
    settings.disk_helper
  end
end
