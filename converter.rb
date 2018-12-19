require_relative 'convertible.rb'
require_relative 'reader.rb'
require_relative 'writable.rb'

include Convertible
include Writable

path = ARGV[0]

reader = Reader.new dir: path
reader.read_all_to_class
flare_docs = reader.parsed_content

remove_namespaces_in flare_docs
remove_attributes_by_name_in flare_docs
remove_attribute_with_value_in flare_docs
remove_elements_and_childs_in flare_docs
remove_empty_docs_in flare_docs
remove_elements_in flare_docs
replace_tags_in flare_docs

# Get class names
#@doc.search('//*[@class]').each {|node| puts node.attribute 'class'}

# remove_declarations_in flare_docs

flare_docs.each do |document|
  write_to_path content: document.doc.to_xml, path: document.path
end

puts 'Finished the conversion!'
