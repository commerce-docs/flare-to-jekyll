# frozen_string_literal: true

require 'flare-docs/toc.rb'

RSpec.describe TOC do
  before(:all) do
    @basedir = File.absolute_path('spec/samples')
  end

  context 'for CE User Guide' do
    let(:toc) { TOC.new base_dir: @basedir, rel_path: 'M2_CE_ONLY_UserGuide_2.3.fltoc' }

    it 'has output path at _data/ce/main_nav.yml' do
      expect(toc.output_path_at(@basedir)).to eq File.join @basedir, '/_data/ce/main-nav.yml'
    end

    it 'has in converted content "label: Getting Started"' do
      expect(toc.generate).to include 'label: Getting Started'
    end

    it 'has a factory for guide tocs' do
      toc.create_guide_tocs
      expect(GuideTOC.all).not_to be_empty
    end

    it 'normalizes links in guides' do
      toc
      TOC.guide_tocs
      expect(GuideTOC.all.first.generate).not_to include '/Content/'
    end

    it 'generates a GuideTOC with name "getting-started"' do
      toc.create_guide_tocs
      test_toc = GuideTOC.all.any? { |toc| toc.guide_name == 'getting-started' }
      expect(test_toc).to be true
    end

    it 'generates guide tocs for all TOC instances' do
      toc
      TOC.guide_tocs
      expect(GuideTOC.all).not_to be_empty
    end
  end

  context 'without guides' do
    let(:toc) { TOC.new base_dir: @basedir, rel_path: 'Marketplace TOC.fltoc' }

    it 'has outputh path at _data/main_nav.yml' do
      expect(toc.output_path_at(@basedir)).to eq File.join @basedir, '/_data/main-nav.yml'
    end

    it 'has in converted content "label: Getting Started"' do
      expect(toc.generate).to include 'label: Getting Started'
    end

    it 'has a factory for guide tocs' do
      toc.create_guide_tocs
      expect(GuideTOC.all).not_to be_empty
    end

    it 'normalizes links in guides' do
      toc
      TOC.guide_tocs
      expect(GuideTOC.all.first.generate).not_to include '/Content/'
    end

    it 'generates a GuideTOC with name "getting-started"' do
      toc.create_guide_tocs
      test_toc = GuideTOC.all.any? { |toc| toc.guide_name == 'getting-started' }
      expect(test_toc).to be true
    end
  end
end
