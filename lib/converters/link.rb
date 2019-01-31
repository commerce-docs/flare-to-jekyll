require 'pathname'

module LinkConverter
  def convert_relative_url(link:,
                           abs_path:,
                           base_dir:,
                           from_ext: 'htm',
                           to_ext: 'md')
    md_root_rel_link =
      resolve_relative_url(link: link, abs_path: abs_path, base_dir: base_dir, from_ext: from_ext, to_ext: to_ext)
    jekyllify md_root_rel_link
  end

  def resolve_relative_url(link:,
                           abs_path:,
                           base_dir:,
                           from_ext: 'htm',
                           to_ext: 'md')
    return link if link.include? '{'
    return link unless link.include? from_ext

    abs_path_dir = File.dirname abs_path
    abs_path_link = File.absolute_path link, abs_path_dir
    root_rel_link = Pathname.new(abs_path_link).relative_path_from(base_dir).to_path
    root_rel_link.sub(/\.#{from_ext}($|#.*)/, ".#{to_ext}")
  end

  def convert_img_src(link:)
    return link if link.include? '{'
    link.sub! %r{\A[.\/]*Resources}, 'images'
    jekyllify link
  end

  def jekyllify(link)
    checked_link = check_for_redirect(link)
    "{{ site.baseurl }}{% link #{checked_link.downcase} %}"
  end

  def check_for_redirect(link)
    redirects = YAML.load(
      File.open('redirects.yml').read
    )
    redirects.each do |redirect|
      link = redirect[:new_path] if redirect[:old_path] == link
    end
    link
  end

  def convert_include_src; end
end
