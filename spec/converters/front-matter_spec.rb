require 'converters/front-matter.rb'
require 'yaml'

RSpec.describe FrontMatter, '#generate' do
  context 'with title and conditions' do
    it 'generates a valid front-matter with title and conditions' do
      front_matter = FrontMatter.new(title: 'My title', conditions: 'Commerce')
      expect(front_matter.generate).to eq "---\ntitle: My title\nconditions: Commerce\n---\n\n"
    end
    it 'generates only title when conditions is nil' do
      front_matter = FrontMatter.new(title: 'My title', conditions: nil)
      expect(front_matter.generate).to eq "---\ntitle: My title\n---\n\n"
    end
    it 'returns empty string when title and conditions are nil' do
      front_matter = FrontMatter.new(title: nil, conditions: nil)
      expect(front_matter.generate).to be_empty
    end
    it 'returns empty string when nor title neither conditions were passed' do
      front_matter = FrontMatter.new
      expect(front_matter.generate).to be_empty
    end
  end
end
