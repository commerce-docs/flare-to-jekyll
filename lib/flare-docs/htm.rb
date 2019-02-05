require_relative '../flare-doc.rb'
require_relative '../converters/front-matter.rb'
require_relative '../converters/kramdownifier.rb'

class HTM < FlareDoc
  include Kramdownifier

  attr_reader :doc, :redirects, :topics

  def initialize(args)
    super
    @doc = parse_file(absolute_path)
  end

  def output_path_at(base_directory)
    md_path = relative_path.sub(/\.htm$/, '.md')
    File.join base_directory, md_path.downcase
  end

  def redirect?
    search_by('//@MadCap:conditions="Default.Redirected"')
  end

  # The doc is empty if there is no <body> that contains any nodes
  def empty?
    search_by('//body/*').empty?
  end

  def relative_path_in_md
    @relative_path.sub '.htm', '.md'
  end
end
