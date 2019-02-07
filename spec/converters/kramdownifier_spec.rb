require 'converters/kramdownifier.rb'

RSpec.describe Kramdownifier do
  include Kramdownifier
  it 'removes CDATA' do
    absolute_path = File.absolute_path 'spec/samples/catalog-create.htm'
    body_content = parse_file(absolute_path).at_css('body')
    expect(body_content.children.any?(&:cdata?)).to be false
  end
  describe 'with {{}} in text' do
    let(:doc) { parse_file(File.absolute_path('spec/samples/catalog-urls-dynamic-media.htm')) }
    it 'escapes {{ }} using Liquid tags' do
      safe_double_braced_content
      expect(to_xml).to include '{% raw %}'
    end
  end
end
