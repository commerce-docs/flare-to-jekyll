# The module contains methods aimed to remove tags form the provided @pages
#
class Cleaner
  attr_reader :config

  def initialize config:
    @config = config
  end

  def config_file
    'remove.yml'
  end
  #
  # List of condition values for the "MadCap:conditions" attribute.
  # The elements that include the listed attributes has to be removed compeletly
  #
  def tags_to_remove_compeletely
    all_options = YAML.load_file config
    all_options.dig 'remove', 'completely'
  end

  def tags_to_remove_condition_only
    all_options = YAML.load_file config
    all_options.dig 'remove', 'condition_only'
  end

  # Remove tags and the text wrapped by the tags listed in the
  # REMOVE_TAG_AND_CONTENT_FOR
  #
  def remove_tags_compeletely_in page
    tags_to_remove_compeletely.each do |condition|
      page.doc
        .xpath("//*[@MadCap:conditions=\"#{condition}\"]")
        .each(&:remove)
    end
  end

  # Remove the "conditions" attributes if the value is included in
  # tags_to_remove_compeletely
  #
  def remove_conditions_only_in page
    tags_to_remove_condition_only.each do |condition|
      page.doc
        .xpath("//*[@MadCap:conditions=\"#{condition}\"]")
        .remove_attr 'conditions'
    end
  end
end
