require_relative 'flare-docs/topic.rb'
require_relative 'flare-docs/image.rb'
require_relative 'flare-docs/include.rb'
class Reader
  attr_reader :dir, :parsed_content, :nonparsable_content

  def initialize(dir:)
    @dir = dir
    @parsed_content = []
    @nonparsable_content = []
  end

  def read_all_to_class
    all_paths_with_extensions('htm').each do |rel_path|
      abs_path = create_filepath dir, rel_path
      # Generate objects to work with using file paths to Flare files
      @parsed_content << Topic.new(abs_path: abs_path, rel_path: rel_path)
    end
    all_paths_with_extensions('flsnp').each do |rel_path|
      abs_path = create_filepath dir, rel_path
      # Generate objects to work with using file paths to Flare files
      @parsed_content << Include.new(abs_path: abs_path, rel_path: rel_path)
    end
    all_paths_with_extensions('jpg', 'png', 'gif').each do |rel_path|
      abs_path = create_filepath dir, rel_path
      # Generate objects to work with using file paths to Flare files
      @nonparsable_content << Image.new(abs_path: abs_path, rel_path: rel_path)
    end
  end

  def all_paths_with_extensions(*extensions)
    paths = []
    extensions.each do |extension|
      paths << read_all_paths_with_extension(extension)
    end
    paths.flatten
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
