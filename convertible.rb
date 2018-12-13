require_relative 'cleaner.rb'

module Convertible
  def cleaner
    Cleaner.new config: 'remove.yml'
  end

  def remove_elements_in(collection)
    collection.each { |doc| cleaner.remove_tags_compeletely_in doc }
  end

  def remove_attributes_in(collection)
    collection.each { |doc| cleaner.remove_conditions_only_in doc }
  end

  def remove_element_itself_in(collection)
    collection.each { |doc| cleaner.remove_element_without_children_in doc }
  end

  def remove_empty_files_in(collection)
    collection.each { |doc| cleaner.remove_file_if_no_root_in doc }
  end
end
