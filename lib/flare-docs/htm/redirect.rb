require_relative '../htm.rb'

class Redirect < HTM
  def real_path_in_md
    return real_url if real_url.start_with? 'http'
    normalized_url = real_url.sub %r{\A/}, ''
    resolve_relative_url(link: normalized_url, abs_path: @absolute_path, base_dir: @base_dir, from_ext: 'html', to_ext: 'md')
  end

  def real_url
    search_by('//meta/@content')[0].value.split('=').last
  end

  def self.generate_yaml
    redirects = []
    all.each do |redirect|
      redirects <<
        {
          old_path: redirect.relative_path_in_md,
          new_path: redirect.real_path_in_md
        }
    end

    File.open('redirects.yml', 'w+') { |file| file.write redirects.to_yaml }
  end

  def empty?
    true
  end
  # <meta http-equiv="refresh" content="0;url=/the/target/catalog.html" />
end
