class Reader
  attr_reader :path

  def initialize(path:)
    @path = path
  end

  def read_all_paths
    all_files_recursively = create_filepath_pattern '**', '*'
    read_paths_by_pattern all_files_recursively
  end

  def read_all_paths_with_extension(extension)
    files_with_extension = create_filepath_pattern('**', "*.#{extension}")
    read_paths_by_pattern files_with_extension
  end

  def read_all_content; end

  def read_all_content_with_extension(extension); end

  def create_filepath_pattern(*strings)
    File.join strings
  end

  def read_paths_by_pattern(pattern)
    Dir.glob pattern, base: path
  end
end
