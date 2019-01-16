require 'erb'

class FrontMatter
  attr_reader :conditions, :title

  def initialize(args)
    @conditions = args[:conditions]
    @title = args[:title]
    @template = ERB.new(File.read('templates/front-matter.erb'))
  end

  def to_s
    @template.result binding
  end
end
