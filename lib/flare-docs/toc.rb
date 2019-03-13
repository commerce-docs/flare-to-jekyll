# frozen_string_literal: true

require_relative '../converters/kramdownifier.rb'
require_relative '../flare-doc.rb'
require_relative 'guide-toc.rb'

class TOC < FlareDoc
  include Kramdownifier

  attr_reader :doc

  def initialize(args)
    super
    # Parse a file by filepath using Nokogiri
    @doc = parse_file absolute_path
  end

  def self.guide_tocs
    all.each(&:create_guide_tocs)
  end

  def edition
    if @relative_path.include?('CE')
      'ce'
    elsif @relative_path.include?('EE')
      'ee'
    elsif @relative_path.include?('B2B')
      'b2b'
    end
  end

  def main_nav_destination
    "_data/#{edition}/main-nav.yml"
  end

  def normalize_links
    search_by('//@Link').each do |link|
      link.value = link.value.sub(%r{/Content(/[^.]+).htm$}, '\1.html')
    end
  end

  def output_path_at(base_directory)
    File.join base_directory, main_nav_destination
  end

  def generate
    main_nav.text
  end

  def main_nav_template
    Nokogiri::XSLT(File.read('lib/flare-docs/templates/main-nav.xsl'))
  end

  def flare_guide_tocs
    normalize_links
    search_by '/CatapultToc/TocEntry'
  end

  def get_new_toc(content, edition)
    GuideTOC.new(
      content: content,
      edition: edition
    )
  end

  def create_guide_tocs
    flare_guide_tocs.each do |toc|
      get_new_toc(toc.to_xml, edition)
    end
  end

  def main_nav
    normalize_links
    main_nav_template.transform doc
  end
end
