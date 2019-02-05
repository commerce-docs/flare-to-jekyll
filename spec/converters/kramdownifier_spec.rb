require 'converters/kramdownifier.rb'

RSpec.describe Kramdownifier do
  include Kramdownifier
  describe '#parse_file' do
    it 'removes CDATA' do
      absolute_path = File.absolute_path 'spec/samples/catalog-create.htm'
      body_content = parse_file(absolute_path).at_css('body')
      expect(body_content.children.any?(&:cdata?)).to be false
    end
  end
end
