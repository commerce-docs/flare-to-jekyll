module Writable
  def write_content_to_path(content:, path:)
    create_directories_for current_directory path
    File.open(path, 'w') { |file| file << content }
  end

  def write_file_to_path(source:, destination:)
    create_directories_for current_directory destination
    FileUtils.cp source, destination
  end

  def current_directory(path)
    File.dirname path
  end

  def create_directories_for(path_to_write)
    FileUtils.mkpath path_to_write
  end
end
