require 'nokogiri'
require 'logger'
require_relative 'link.rb'
# Converts input HTML to kramdown
module Kramdownifier
  include LinkConverter

  DEFAULT_OPTIONS =
    { html_to_native: true, line_width: 1000, input: 'html' }.freeze

  def logger
    @@logger ||= Logger.new('kramdowinifier.log', progname: 'Kramdownifier')
  end

  def kramdownify(string, options = {})
    logger.info 'Converting HTML to Kramdown'
    document = Kramdown::Document.new(string, DEFAULT_OPTIONS.merge(options))
    converted_content = document.to_kramdown
    logger.info 'Finished converting HTML to Kramdown'
    converted_content
  end

  # For parse options, trefer tohttps://nokogiri.org/tutorials/parsing_an_html_xml_document.html
  def parse_file(absolute_path)
    content = File.open(absolute_path)
    Nokogiri::XML(content, &:nocdata)
  end

  def search_by(selector)
    doc.search selector
  end

  def to_xml
    doc.to_xml
  end

  def internal_links
    search_by '//a[not(starts-with(@href, "http"))]'
  end

  def images
    search_by 'img'
  end

  def notes
    search_by 'p[class^=note]'
  end

  def convert_notes
    logger.info 'Converting notes'
    notes.each do |note|
      convert_a_note(note)
    end
    logger.info 'Finished converting notes'
  end

  def convert_a_note(note)
    note.node_name = 'div'
    note.set_attribute 'class', 'bs-callout bs-callout-info'
    note.set_attribute 'markdown', '1'
  end

  def convert_internal_links
    internal_links.each do |link|
      href = link['href']
      next unless href
      link['href'] =
        convert_relative_url link: href,
                             abs_path: absolute_path,
                             base_dir: base_dir
      link.replace link.children if removed?(link['href'])
    end
  end

  def remove_empty_links
    internal_links
  end

  def convert_links_to_images
    images.each do |img|
      src = img['src']
      next unless src
      img['src'] =
        convert_img_src link: src
    end
  end

  def kramdown_content
    logger.info "Kramdownifying #{relative_path}"
    convert_notes
    convert_includes
    convert_variables
    safe_double_braced_content
    content = kramdownify search_by('/html/body').to_xml
    content = replace_collapsibles_in content
    remove_liquid_escaping_in content
  end

  def includes
    search_by 'include'
  end

  def variables
    search_by 'variable[name^="MyVariables.Product"]'
  end

  def convert_includes
    logger.info 'Converting includes'
    includes.each do |element|
      element.node_name = 'p'
      link = element['src']
      converted_link = convert_include_src link: link
      element.content = "{% include #{converted_link} %}"
      element.remove_attribute 'src'
    end
    logger.info 'Finished converting includes'
  end

  def convert_variables
    logger.info 'Converting variables'
    variables.each do |node|
      node.replace 'Magento'
    end
    logger.info 'Finished converting variables'
  end

  def text_nodes_with_double_braced_content
    search_by '//text()[contains(.,"{{")]'
  end

  def safe_double_braced_content
    logger.info 'Escaping {{text}}'
    text_nodes_with_double_braced_content.each do |node|
      old_content = node.content
      safe_content = '{% raw %}' + old_content + '{% endraw %}'
      node.content = safe_content
    end
    logger.info 'Finished escaping {{text}}'
  end

  def replace_collapsibles_in(content)
    logger.info 'Converting collapsibles'
    content.gsub(/<dropDownBody[^>]*>/, "\n{% collapsible %}\n")
           .gsub('</dropDownBody>', "\n{% endcollapsible %}\n")
  end

  def remove_liquid_escaping_in(content)
    content.gsub '\{%', '{%'
  end
end
