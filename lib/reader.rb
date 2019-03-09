require_relative 'flare-docs/htm/topic.rb'
require_relative 'flare-docs/htm/redirect.rb'
require_relative 'flare-docs/image.rb'
require_relative 'flare-docs/include.rb'
require_relative 'flare-docs/toc.rb'

class Reader
  attr_reader :parsable_content, :nonparsable_content

  def initialize(source_dir:)
    @source_dir = source_dir
    @parsable_content = []
    @nonparsable_content = []
    @redirects = []
  end

  def dir
    create_filepath @source_dir, 'Content'
  end

  def read_all_to_class
    all_paths_with_extensions('htm').each do |rel_path|
      # Generate objects to work with using file paths to Flare files

      htm_file = HTM.new(base_dir: dir, rel_path: rel_path)

      if htm_file.redirect?
        @redirects << Redirect.new(base_dir: dir, rel_path: rel_path)
      else
        @parsable_content << Topic.new(base_dir: dir, rel_path: rel_path)
      end
    end
    all_paths_with_extensions('flsnp').each do |rel_path|
      # Generate objects to work with using file paths to Flare files
      @parsable_content << Include.new(base_dir: dir, rel_path: rel_path)
    end
    all_paths_with_extensions('jpg', 'jpeg', 'png', 'gif').each do |rel_path|
      # Generate objects to work with using file paths to Flare files
      @nonparsable_content << Image.new(base_dir: dir, rel_path: rel_path)
    end
    read_tocs.each do |rel_path|
      @parsable_content << TOC.new(base_dir: @source_dir, rel_path: rel_path)
    end
  end

  def save_redirects_to_yaml
    Redirect.generate_yaml
  end

  def save_removed_paths_to_yaml
    Topic.save_empties_to_yaml
  end

  def topics
    Topic.all
  end

  def tocs
    TOC.all
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

  def read_tocs
    Dir.glob 'Project/TOCs/*UserGuide*', base: @source_dir
  end
end
