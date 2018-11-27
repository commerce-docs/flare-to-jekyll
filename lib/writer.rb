require 'fileutils'

class Writer
  attr_reader :path

  def initialize path:
    @path = path
  end

  def write_to_path content:
    create_directories_for current_directory
    File.write path, content
  end

  def current_directory
    File.dirname path
  end

  def create_directories_for path_to_write
    FileUtils.mkpath path_to_write
  end
end
