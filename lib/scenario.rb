require_relative 'writable.rb'
require_relative 'convertible.rb'
require_relative 'reader.rb'

class Scenario
  include ::Convertible
  include ::Writable

  def initialize(input_dir, jekyll_output_dir)
    @input_dir = input_dir
    @jekyll_output_dir = jekyll_output_dir
  end

  def execute
    reader = Reader.new dir: @input_dir
    reader.read_all_to_class
    flare_docs = reader.parsed_content
    assets = reader.nonparsable_content

    all_docs = flare_docs + assets

    remove_namespaces_in flare_docs
    remove_attributes_by_name_in flare_docs
    remove_attribute_with_value_in flare_docs
    remove_elements_and_childs_in flare_docs
    remove_empty_docs_in flare_docs
    remove_elements_in flare_docs
    replace_tags_in flare_docs

    # Not implemented
    # add_parent_in flare_docs

    # Get class names
    # @doc.search('//*[@class]').each {|node| puts node.attribute 'class'
    # Not implemented
    # remove_declarations_in flare_docs

    flare_docs.each do |document|
      write_to_path content: document.to_xml,
                    path: document.absolute_path
    end

    puts 'Finished conversion to HTML!'

    all_docs.each do |document|
      write_to_path content: document.generate,
                    path: document.output_path_at(@jekyll_output_dir)
    end

    puts 'Finished conversion to Kramdown!'
  end
end
