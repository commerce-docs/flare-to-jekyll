require 'nokogiri'
require 'yaml'

class FlareDoc
  attr_accessor :path, :doc

  def initialize(args)
    @path = args[:path]
    # Parse a file by file path using Nokogiri
    @doc = File.open(path) { |f| Nokogiri::XML(f) }
  end

  # Get an array of all FlareDoc objects
  def self.all
    ObjectSpace.each_object(self).to_a
  end

  # Get the number of the FlareDoc objetcs created
  def self.count
    all.count
  end

  # Get values of the <html> tag attributes of the Flare document
  def html_attributes
    doc.root.attributes
  end

  def content
    doc.inner_html
  end

  # Get <body> of the Flare document
  # def body
  #   doc.root.elements['body']
  # end

  # def title
  #   { 'title' => title }
  # end

  # def scope
  #   #MadCap:conditions="Default.EE-B2B"
  #   { 'scope' => scope }
  # end
end
