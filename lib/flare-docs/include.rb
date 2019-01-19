require_relative '../converters/kramdownifier.rb'
require_relative '../flare-doc.rb'

class Include < FlareDoc
  include Kramdownifier

  def output_path_at(base_directory)
    @relative_path.sub!(/\.flsnp$/, '.md')
    File.join base_directory, @relative_path
  end

  def generate
    @relative_path.sub! 'Resources/Snippets', '_includes'
    kramdown_content
  end
end
