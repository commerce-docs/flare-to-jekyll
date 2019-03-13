class Image < FlareDoc

  def initialize(args)
    super
  end

  def destination
    @relative_path.sub('Resources', 'images').downcase
  end

  def output_path_at(base_directory)
    File.join base_directory, destination
  end

  def parsable?
    false
  end
end
