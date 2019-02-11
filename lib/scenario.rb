require_relative 'writable.rb'
require_relative 'convertible.rb'
require_relative 'reader.rb'
require_relative 'configuration.rb'

class Scenario
  include ::Convertible
  include ::Writable

  def initialize
    @config = Configuration.instance.data
    @base_dir = File.expand_path @config['flare_dir']
    @jekyll_dir = File.expand_path @config['jekyll_dir']
  end

  def execute
    reader = Reader.new source_dir: @base_dir
    reader.read_all_to_class
    reader.save_redirects_to_yaml #unless File.exist? 'redirects.yml'

    flare_docs = reader.parsable_content
    assets = reader.nonparsable_content
    # topics = reader.topics

    remove_namespaces_in flare_docs
    remove_attributes_by_name_in flare_docs
    remove_attribute_with_value_in flare_docs
    remove_elements_and_childs_in flare_docs
    reader.save_removed_paths_to_yaml

    remove_empty_docs_in flare_docs
    remove_elements_in flare_docs
    replace_tags_in flare_docs
    replace_attr_values_in flare_docs
    convert_internal_links_in flare_docs
    convert_links_to_images_in flare_docs

    flare_docs.each do |document|
      write_content_to_path content: document.to_xml,
                            path: document.absolute_path
    end

    puts 'Finished conversion to HTML!'

    puts 'Converting text to Kramdown ...'
    flare_docs.each do |document|
      write_content_to_path content: document.generate,
                            path: document.output_path_at(@jekyll_dir)
    end

    puts 'Copying binaries to follow Jekyll structure ...'

    assets.each do |document|
      write_file_to_path source: document.absolute_path,
                         destination: document.output_path_at(@jekyll_dir)
    end

    puts 'Finished conversion to Kramdown!'
  end
end

# Not implemented
# add_parent_in flare_docs

# Get class names
# @doc.search('//*[@class]').each {|node| puts node.attribute 'class'
# Not implemented
# remove_declarations_in flare_docs
