class Image < FlareDoc

  def initialize(args)
    super
  end

  def generate
    @relative_path.sub! 'Resources', 'images'
  end

  def output_path_at(base_directory)
    File.join base_directory, relative_path
  end
end
