require 'yaml'
# The module contains methods aimed to remove tags form the provided @pages
#
class Cleaner
  attr_reader :config

  def initialize(config:)
    @config = YAML.load_file 'config.yml'
  end

  #
  # List of condition values for the "MadCap:conditions" attribute.
  # The elements that include the listed attributes has to be removed compeletly
  #
  def tags_to_remove_compeletely
    config.dig 'remove', 'completely'
  end

  def tags_to_remove_condition_only
    config.dig 'remove', 'condition_only'
  end

  def tags_to_replace_elements_with_children
    config.dig 'remove', 'element_itself'
  end

  def tags_to_swap
    config.dig 'swap'
  end

  def remove_namespaces_on_a page
    page.doc.remove_namespaces!
  end

  # Remove tags and the text wrapped by the tags listed in the
  # REMOVE_TAG_AND_CONTENT_FOR
  #
  def remove_tags_compeletely_on_a page
    tags_to_remove_compeletely.each do |selector|
      page.doc
          .search(selector)
          .each(&:remove)
    end
  end

  # Remove the "conditions" attributes if the value is included in
  # tags_to_remove_compeletely
  #
  def remove_conditions_only_on_a page
    tags_to_remove_condition_only.each do |selector|
      page.doc
          .search(selector)
          .remove_attr 'conditions'
    end
  end

  # Replace the element with its children.
  # Element names are listed in the remove > element_itself in the remove.yml file.
  #
  def remove_element_without_children_on_a page
    tags_to_replace_elements_with_children.each do |tag|
      page.doc.search(tag).each do |element|
        element.replace element.children
      end
    end
  end

  # def remove_xml_declaration_in(page)
  #   page.doc.to_s.sub("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n", '')
  # end

  def remove_empty page
    File.delete page.path
  end

  def replace_tags_on_a page
    tags_to_swap.each do |new_name, old_names|
      swap_tag_names(page, new_name, old_names)
    end
  end

  def swap_tag_names(page, new_name, old_names)
    old_names.each do |old_name|
      page.doc.search(old_name).each do |element|
        element.node_name = new_name
      end
    end
  end
end
