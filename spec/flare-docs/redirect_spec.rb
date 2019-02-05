require 'flare-docs/htm/redirect.rb'

RSpec.describe Redirect do
  before(:all) do
    @basedir = File.absolute_path('spec/samples')
  end

  context 'at the root folder' do
    let(:redirect) { Redirect.new base_dir: @basedir, rel_path: 'catalog-create.htm' }

    it 'is a redirect' do
      expect(redirect).to be_redirect
    end

    it 'gets a URL to the redirected page' do
      expect(redirect.real_url).to eq 'category-root.html'
    end

    it 'generates a relative path for the real URL' do
      expect(redirect.real_path_in_md).to eq 'category-root.md'
    end

    it 'converts relative path to md' do
      expect(redirect.relative_path_in_md).to eq 'catalog-create.md'
    end
  end
  context 'at subfolder and with url starting with slash' do
    let(:redirect) { Redirect.new base_dir: @basedir, rel_path: 'catalog/catalog-create.htm' }

    it 'removes the leading slash and converts a url to a real path' do
      expect(redirect.real_path_in_md).to eq 'catalog/category-root.md'
    end
  end
end
