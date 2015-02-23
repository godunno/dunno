require_relative 'extension'

module Catalog
  class ImageExtractor
    attr_reader :object

    def self.extract(object)
      new(object).extract
    end

    def initialize(object)
      @object = object
    end

    def extract
      object.path if image?
    end

    private

    def image?
      extension.image?
    end

    def extension
      @extension ||= Catalog::Extension.from(object.name)
    end
  end
end
