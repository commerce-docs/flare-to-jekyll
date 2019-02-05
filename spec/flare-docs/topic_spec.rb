require 'flare-docs/htm/topic.rb'

RSpec.describe Topic do
  before(:all) do
    @basedir = File.absolute_path('spec/samples')
  end

  context 'with regular content' do
    let(:topic) { Topic.new base_dir: @basedir, rel_path: 'catalog/attribute-best-practices.htm'}

    it 'is not a redirect' do
      expect(topic).not_to be_redirect
    end
    it 'is not empty' do
      expect(topic).not_to be_empty
    end
  end

  context 'with redirect' do
    let(:topic) { Topic.new base_dir: @basedir, rel_path: 'catalog-create.htm' }

    it 'is a redirect' do
      expect(topic).to be_redirect
    end
    it 'is empty' do
      expect(topic).to be_empty
    end
  end
  context 'with empty body' do
    let(:topic) { Topic.new base_dir: @basedir, rel_path: 'empty-topic.htm' }

    it 'is empty' do
      expect(topic).to be_empty
    end
  end
end
