require 'configuration.rb'
require 'yaml'

RSpec.describe Configuration, '#data' do
    it 'checks if configuration is available' do
      configuration = Configuration.instance
      expect(configuration.data).not_to be_empty
    end
end
