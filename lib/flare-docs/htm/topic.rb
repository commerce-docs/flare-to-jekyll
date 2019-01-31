require_relative '../htm.rb'
require_relative '../../converters/front-matter.rb'

class Topic < HTM

  def front_matter
    @front_matter = FrontMatter.new(conditions: conditions, title: title)
    @front_matter.generate
  end

  def conditions
    conditions = doc.at_xpath('//html/@conditions')
    conditions.value if conditions
  end

  def title
    title = search_by('h1')
    title.inner_text.strip if title
  end

  def generate
    front_matter + kramdown_content
  end
end
