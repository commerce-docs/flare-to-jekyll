# Generate front-matter from provided argumemts
class FrontMatter
  def initialize(args)
    @args = args
  end

  def generate
    @args.compact!
    return '' if @args.empty?
    @args.transform_keys!(&:to_s)
    @args.to_yaml + "---\n\n"
  end
end
