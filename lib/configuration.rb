require 'singleton'
require 'yaml'

class Configuration
  include Singleton
  
  attr_accessor :data
  
  def initialize
    @data = YAML.load(
      File.open('config.yml').read
    )
  end
end
