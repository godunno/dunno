require_relative 'extension'

module Catalog
  class ExtensionThumbnailExtractor
    SUPPORTED_EXTENSIONS = %w(doc)
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def extract
      extension = Catalog::Extension.from(object.name)
      return unless SUPPORTED_EXTENSIONS.include?(extension)
      extension
    end

    def self.extract(name)
      new(name).extract
    end
  end
end
