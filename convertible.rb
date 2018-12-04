require_relative 'cleaner.rb'

module Convertible

  def cleaner
    Cleaner.new config: 'remove.yml'
  end

  def varnish_elements_in(collection)
    collection.each { |element| cleaner.remove_tags_compeletely_in element }
  end

  def varnish_attributes_in(collection)
    collection.each { |attribute| cleaner.remove_conditions_only_in attribute }
  end
end
