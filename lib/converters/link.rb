require 'pathname'

module LinkConverter
  def convert_relative_url(link:,
                           abs_path:,
                           base_dir:,
                           from_ext: 'htm',
                           to_ext: 'md')

    return link if link.include? '{'
    return link unless link.include? from_ext
    return link if link.include? ':'

    md_root_rel_link =
      resolve_relative_url(link: link, abs_path: abs_path, base_dir: base_dir, from_ext: from_ext, to_ext: to_ext)
    jekyllify md_root_rel_link
  end

  def resolve_relative_url(link:,
                           abs_path:,
                           base_dir:,
                           from_ext: 'htm',
                           to_ext: 'md')
    abs_path_dir = File.dirname abs_path
    abs_path_link = Pathname.new(
      File.absolute_path(link, abs_path_dir)
    )
    base_path = Pathname.new(base_dir)
    root_rel_link = abs_path_link.relative_path_from(base_path).to_path
    root_rel_link.sub(/\.#{from_ext}($|#.*)/, ".#{to_ext}")
  end

  def convert_img_src(link:)
    return link if link.include? '{'
    new_path = link.sub %r{\A[.\/]*Resources|\.\.(?=\/Images)}, 'images'
    jekyllify new_path
  end

  def jekyllify(link)
    checked_link = check_for_redirect(link)
    return checked_link if checked_link.start_with? 'http'
    "{% link #{normalize checked_link} %}"
  end

  def check_for_redirect(link)
    redirects = load_file 'redirects.yml'
    redirects.each do |redirect|
      link = redirect[:new_path] if redirect[:old_path] == link
    end
    link
  end

  def normalize(link)
    link.downcase.tr ' ', '-'
  end

  def load_file(file)
    YAML.load_file file
  end

  def removed?(link)
    deleted_files = load_file 'removed.yml'
    deleted_files.any? { |path| link.include?(normalize(path)) }
  end

  def convert_include_src(link:)
    new_path = link.sub %r{\A[.\/]*Resources/Snippets/}, ''
    normalized_path = normalize new_path
    normalized_path.sub(/\.flsnp$/, '.md')
  end
end
