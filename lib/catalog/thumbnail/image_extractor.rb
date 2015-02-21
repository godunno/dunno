require_relative 'extension'

module Catalog
  class ImageExtractor
    SUPPORTED_EXTENSIONS = %w(jpg jpeg png svg gif)
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def extract
      object.path if image?
    end

    def image?
      SUPPORTED_EXTENSIONS.include? extension
    end

    def extension
      Extension.from(object.name)
    end
  end
end
