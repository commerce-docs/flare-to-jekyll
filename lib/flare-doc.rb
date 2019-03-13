class FlareDoc
  attr_accessor :absolute_path, :relative_path, :base_dir

  def initialize(args)
    @base_dir = args[:base_dir]
    @relative_path = args[:rel_path]
    @absolute_path = File.join base_dir, relative_path
  end

  def output_path_at(base_directory)
    raise "The method is not implemented for the #{self.class} class"
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def empty?
    false
  end

  def parsable?
    true
  end
end
