# frozen_string_literal: true

require_relative '../flare-doc.rb'
require 'active_support/core_ext/hash/conversions'
require 'yaml'

class GuideTOC < FlareDoc
  attr_reader :content, :edition

  def initialize(args)
    @content = args[:content]
    @edition = args[:edition]
  end

  def generate
    normalized_content
  end

  def content_in_hash
    Hash.from_xml content
  end

  def normalized_content
    original_content = content_in_hash['TocEntry']
    normalized_content = keep_informative_elements(original_content)
    normalized_content.delete 'url'
    normalized_content['pages'] = normalized_content.delete('children')
    normalized_content.to_yaml
  end

  def keep_informative_elements(hash)
    filter hash
    convert_hash_values_to_array(hash)
    hash.each_value do |v|
      case v
      when Array
        v.map { |item| keep_informative_elements(item) if item.is_a? Hash }
      when Hash
        keep_informative_elements(v)
      end
    end
  end

  def convert_hash_values_to_array(hash)
    hash.transform_values! do |v|
      v.is_a?(Hash) ? Array.wrap(v) : v
    end
  end

  def filter(hash)
    valid_keys = %w[Title Link TocEntry]
    hash.keep_if { |key,_| valid_keys.any? key }
    key_map = { 'Title' => 'label', 'Link' => 'url', 'TocEntry' => 'children' }
    hash.transform_keys! { |k| key_map[k] }
  end

  def guide_name
    filename = content_in_hash['TocEntry']['Link']
    File.basename filename, '.*'
  end

  def destination
    "_data/#{edition}/toc/#{guide_name}.yml"
  end

  def output_path_at(base_directory)
    File.join base_directory, destination
  end
end
