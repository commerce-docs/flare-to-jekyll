class FlareDoc
  attr_accessor :absolute_path, :relative_path

  def initialize(args)
    @absolute_path = args[:abs_path]
    @relative_path = args[:rel_path]
  end

  def output_path_at(base_directory)
    raise "The method is not implemented for the #{self.class} class"
  end
end
