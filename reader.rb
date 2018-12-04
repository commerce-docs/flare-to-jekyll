require_relative 'flare-doc.rb'
class Reader
  attr_reader :dir, :parsed_content

  def initialize(dir:)
    @dir = dir
    @parsed_content = []
  end

  def read_all_to_class
    read_all_paths_with_extension('htm').each do |local_path|
      full_path = create_filepath dir, local_path
      # Generate objects to work with using file paths to Flare files
      @parsed_content << FlareDoc.new(path: full_path)
    end
  end

  def read_all_paths
    all_files_recursively = create_filepath '**', '*'
    read_paths_by_pattern all_files_recursively
  end

  def read_all_paths_with_extension(extension)
    files_with_extension = create_filepath('**', "*.#{extension}")
    read_paths_by_pattern files_with_extension
  end

  def create_filepath(*strings)
    File.join strings
  end

  def read_paths_by_pattern(pattern)
    Dir.glob pattern, base: dir
  end
end
