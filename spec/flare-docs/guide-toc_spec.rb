# frozen_string_literal: true

require 'flare-docs/guide-toc.rb'

RSpec.describe GuideTOC do
  before(:all) do
    @basedir = File.absolute_path('spec/samples')
    @content = File.read(
      File.join(@basedir, 'getting-started.xhtml')
    )
  end

  let(:toc) do
    GuideTOC.new content: @content, edition: 'ce'
  end

  it 'has a destination' do
    expect(toc.destination).to eq '_data/ce/toc/getting-started.yml'
  end

  it 'normalizes content' do
    expect(toc.normalized_content).to be_a String
  end

  it 'generates "label: Getting Started"' do
    expect(toc.generate).to include "label: Getting Started\npages:\n"
  end

  it 'it does not have a "label" with no prefix (have to be prefixed with "-")' do
    expect(toc.normalized_content).not_to include '  label'
  end
end
