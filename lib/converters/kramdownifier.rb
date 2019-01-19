require 'nokogiri'
# Converts input HTML to kramdown
module Kramdownifier
  attr_reader :doc

  def initialize(args)
    super
    # Parse a file by filepath using Nokogiri
    @doc = File.open(absolute_path) { |f| Nokogiri::XML(f) }
  end

  DEFAULT_OPTIONS = { html_to_native: true, line_width: 1000, input: 'html' }

  def kramdownify(string, options = {})
    document = Kramdown::Document.new(string, DEFAULT_OPTIONS.merge(options))
    document.to_kramdown
  end

  def empty?
    doc.root.nil?
  end

  def search_by(selector)
    doc.search selector
  end

  def to_xml
    doc.to_xml
  end

  def kramdown_content
    kramdownify doc.to_html
  end
end
