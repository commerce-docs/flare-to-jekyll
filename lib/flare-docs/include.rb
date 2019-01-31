require_relative '../converters/kramdownifier.rb'
require_relative '../flare-doc.rb'

class Include < FlareDoc
  include Kramdownifier

  attr_reader :doc

  def initialize(args)
    super
    # Parse a file by filepath using Nokogiri
    @doc = parse_file absolute_path
  end

  def output_path_at(base_directory)
    @relative_path.sub!(/\.flsnp$/, '.md')
    File.join base_directory, @relative_path
  end

  def generate
    @relative_path.sub! 'Resources/Snippets', '_includes'
    kramdown_content
  end
end
