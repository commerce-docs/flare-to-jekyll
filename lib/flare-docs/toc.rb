require_relative '../converters/kramdownifier.rb'
require_relative '../flare-doc.rb'

class TOC < FlareDoc
  include Kramdownifier

  attr_reader :doc

  def initialize(args)
    super
    # Parse a file by filepath using Nokogiri
    @doc = parse_file absolute_path
  end

  def destination
    case @relative_path
    when 'Project/TOCs/M2_CE_ONLY_UserGuide_2.3.fltoc'
      '_data/ce/main-nav.yml'
    when 'Project/TOCs/M2_EE_ONLY_UserGuide_2.3.fltoc'
      '_data/ee/main-nav.yml'
    when 'Project/TOCs/M2_B2B_ONLY_UserGuide_2.3.fltoc'
      '_data/b2b/main-nav.yml'
    end
  end

  def normalize_links
    search_by('//@Link').each do |link|
      link.value = link.value.sub(%r{/Content(/[^.]+).htm$}, '\1/')
    end
  end

  def output_path_at(base_directory)
    File.join base_directory, destination
  end

  def generate
    normalize_links
    main_nav.text
  end

  def main_nav_template
    Nokogiri::XSLT(File.read('lib/flare-docs/templates/main-nav.xsl'))
  end

  def main_nav
    main_nav_template.transform doc
  end

  def generate_main_nav
    main_nav.to_xml
  end
end
