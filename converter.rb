require_relative 'convertible.rb'
require_relative 'reader.rb'
require_relative 'writable.rb'

include Convertible
include Writable

path = ARGV[0]

reader = Reader.new dir: path
reader.read_all_to_class
flare_docs = reader.parsed_content

remove_elements_in flare_docs

remove_empty_files_in flare_docs

reader.read_all_to_class
flare_docs = reader.parsed_content

remove_attributes_in flare_docs

remove_element_itself_in flare_docs

flare_docs.each do |document|
  write_to_path content: document.doc.to_xml, path: document.path
end
