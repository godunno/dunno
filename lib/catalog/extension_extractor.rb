require_relative 'extension'

module Catalog
  class ExtensionExtractor
    SUPPORTED_EXTENSIONS = %w(doc docx ppt pptx xls xlsx ppt pptx pdf html txt rtf key pages numbers)
    attr_reader :object

    def self.extract(object)
      new(object).extract
    end

    def initialize(object)
      @object = object
    end

    def extract
      return unless SUPPORTED_EXTENSIONS.include?(extension)
      extension
    end

    private

    def extension
      @extension ||= Catalog::Extension.from(object.name)
    end
  end
end
