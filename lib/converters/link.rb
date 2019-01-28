require 'pathname'

module LinkConverter
  def convert_a_href(link:, abs_path:, base_dir:)
    return link if link.include? '{'
    return link unless link.include? '.htm'

    abs_path_dir = File.dirname abs_path
    abs_path_link = File.absolute_path link, abs_path_dir
    root_rel_link = Pathname.new(abs_path_link).relative_path_from base_dir
    md_root_rel_link = root_rel_link.sub(%r{\.htm($|#.*)}, '.md').to_path
    jekyllify md_root_rel_link
  end

  def convert_img_src(link:)
    return link if link.include? '{'
    link.sub! %r{\A[.\/]*Resources}, 'images'
    jekyllify link
  end

  def jekyllify(link)
    "{{ site.baseurl }}{% link #{link.downcase} %}"
  end

  def convert_include_src; end
end
