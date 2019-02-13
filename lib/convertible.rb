require_relative 'cleaner.rb'

module Convertible
  def cleaner
    Cleaner.new
  end

  def remove_namespaces_in(collection)
    puts 'Removing namespaces...'
    collection.each { |doc| cleaner.remove_namespaces_on_a doc }
    puts 'Done!'
  end

  def remove_elements_and_childs_in(collection)
    puts 'Removing elements compeletely...'
    collection.each { |doc| cleaner.remove_tags_compeletely_on_a doc }
    puts 'Done!'
  end

  def remove_attributes_by_name_in(collection)
    puts 'Removing attributes by name...'
    collection.each { |doc| cleaner.remove_attributes_by_name_on_a doc }
    puts 'Done!'
  end

  def remove_attribute_with_value_in(collection)
    puts 'Removing attributes with specified values...'
    collection.each { |doc| cleaner.remove_attribute_with_value_on_a doc }
    puts 'Done!'
  end

  def remove_elements_in(collection)
    puts 'Removing elements, but keeping child elements...'
    collection.each { |doc| cleaner.remove_element_without_children_on_a doc }
    puts 'Done!'
  end

  def remove_empty_docs_in(collection)
    puts 'Removining empty files...'
    removed_paths = []
    collection.map! do |doc|
      if doc.empty?
        cleaner.remove_empty doc
        nil
      else
        doc
      end
    end
    collection.compact!
    puts 'Done!'
  end

  def replace_tags_in(collection)
    puts 'Swapping tags...'
    collection.each { |doc| cleaner.replace_tags_on_a doc }
    puts 'Done!'
  end

  def replace_attr_values_in(collection)
    puts 'Swapping attribue values ...'
    collection.each { |doc| cleaner.replace_attr_values_on_a doc }
    puts 'Done!'
  end

  def add_parent_in(collection)
    puts 'Adding parent tags...'
    collection.each { |doc| cleaner.add_parent_on_a doc }
    puts 'Done!'
  end

  def convert_internal_links_in(collection)
    puts 'Converting internal links...'
    collection.each(&:convert_internal_links)
    puts 'Done!'
  end

  def convert_links_to_images_in(collection)
    puts 'Converting links to images'
    collection.each(&:convert_links_to_images)
    puts 'Done!'
  end

  # def remove_declarations_in collection
  #   collection.each { |doc| cleaner.remove_xml_declaration_in doc }
  # end
end
