require 'flare-docs/htm/topic.rb'

RSpec.describe Topic do

  context 'with regular content' do
    let(:topic) { Topic.new base_dir: '/Users/dmytroshevtsov/Projects/rubydev/flare-to-jekyll/spec/flare-docs/samples', rel_path: 'catalog/attribute-best-practices.htm'}

    it 'is not a redirect' do
      expect(topic).not_to be_redirect
    end
  end

  context 'with redirect' do
    let(:topic) { Topic.new base_dir: '/Users/dmytroshevtsov/Projects/rubydev/flare-to-jekyll/spec/flare-docs/samples', rel_path: 'catalog-create.htm' }

    it 'is a redirect' do
      expect(topic).to be_redirect
    end
  end
end
