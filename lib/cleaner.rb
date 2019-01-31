# The module contains methods aimed to remove tags form the provided @pages
#
class Cleaner
  attr_reader :config

  def initialize
    @config = Configuration.instance.data
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

  def tags_to_remove_attribute_by_name
    config.dig 'remove', 'attribute'
  end

  def tags_to_remove_attribute_with_value
    config.dig 'remove', 'attribute_with_value'
  end

  def tags_to_replace_elements_with_children
    config.dig 'remove', 'element_itself'
  end

  def tags_to_swap
    config.dig 'swap'
  end

  def tags_to_add_parent
    config.dig 'add', 'parent'
  end

  def remove_namespaces_on_a(page)
    page.doc.remove_namespaces!
  end

  # Remove tags and the text wrapped by the tags listed in the
  # REMOVE_TAG_AND_CONTENT_FOR
  #
  def remove_tags_compeletely_on_a(page)
    tags_to_remove_compeletely.each do |selector|
      page.search_by(selector)
          .each(&:remove)
    end
  end

  def remove_attributes_by_name_on_a(page)
    tags_to_remove_attribute_by_name.each do |attr_name|
      selector = "[#{attr_name}]"
      page.search_by(selector)
          .remove_attr attr_name
    end
  end

  def remove_attribute_with_value_on_a(page)
    tags_to_remove_attribute_with_value.each do |name, values|
      values.each do |value|
        selector = "[#{name}=\"#{value}\"]"
        page.search_by(selector).each do |node|
          node.attributes.each do |attribute_name, attr|
            node.remove_attribute(attribute_name) if attr.value == value
          end
        end
      end
    end
  end

  # Replace the element with its children.
  # Element names are listed in the remove > element_itself in the remove.yml file.
  #
  def remove_element_without_children_on_a(page)
    tags_to_replace_elements_with_children.each do |selector|
      page.search_by(selector).each do |element|
        element.replace element.children
      end
    end
  rescue ArgumentError => e
    puts e.message
    puts "The issue is in #{page.relative_path}"
  end

  # def remove_xml_declaration_in(page)
  #   page.doc.to_s.sub("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n", '')
  # end

  def remove_empty(page)
    File.delete page.absolute_path
  end

  def replace_tags_on_a(page)
    tags_to_swap.each do |new_name, old_names|
      swap_tag_names(page, new_name, old_names)
    end
  end

  def swap_tag_names(page, new_name, old_names)
    old_names.each do |old_name|
      page.search_by(old_name).each do |element|
        element.node_name = new_name
      end
    end
  end

  def add_parent_on_a(page)
    tags_to_add_parent.each do |parent_tag, elements|
      elements.each do |element|
        page.search_by(element)
            .wrap("<#{parent_tag}/>")
      end
    end
  end
end
