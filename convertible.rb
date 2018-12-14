require_relative 'cleaner.rb'

module Convertible
  def cleaner
    Cleaner.new config: 'remove.yml'
  end

  def remove_elements_and_childs_in(collection)
    collection.each { |doc| cleaner.remove_tags_compeletely_in doc }
  end

  def remove_attributes_in(collection)
    collection.each { |doc| cleaner.remove_conditions_only_in doc }
  end

  def remove_elements_in(collection)
    collection.each { |doc| cleaner.remove_element_without_children_in doc }
  end

  def remove_empty_docs_in(collection)
    collection.map! do |doc|
      if doc.empty?
        cleaner.remove_empty doc
        nil
      else
        doc
      end
    end
    collection.compact!
  end
end
