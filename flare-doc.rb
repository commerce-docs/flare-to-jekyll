require 'nokogiri'
require_relative 'converters/kramdown.rb'

class FlareDoc
  include Converter

  attr_accessor :absolute_path, :relative_path, :doc

  def initialize(args)
    @absolute_path = args[:abs_path]
    @relative_path = args[:rel_path]
    # Parse a file by file path using Nokogiri
    @doc = File.open(absolute_path) { |f| Nokogiri::XML(f) }
  end

  def empty?
    doc.root.nil?
  end

  def search_by(selector)
    doc.search selector
  end

  def to_xml
    @doc.to_xml
  end

  def to_kramdown
    kramdownify @doc.to_html
  end

  def relative_md_path_at(base_directory)
    md_path = relative_path.sub(/\.htm$|\.flsnp$/, '.md')
    File.join base_directory, md_path
  end
end
