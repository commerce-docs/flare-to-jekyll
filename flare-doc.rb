require 'nokogiri'

class FlareDoc
  attr_accessor :path, :doc

  def initialize(args)
    @path = args[:path]
    # Parse a file by file path using Nokogiri
    @doc = File.open(path) { |f| Nokogiri::XML(f) }
  end

  def empty?
    doc.root.nil?
  end

  def search_by selector
    doc.search selector
  end
end
