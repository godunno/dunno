require_relative 'extension'

module Catalog
  class ExtensionExtractor
    attr_reader :object

    def self.extract(object)
      new(object).extract
    end

    def initialize(object)
      @object = object
    end

    def extract
      return unless supported?
      extension_name
    end

    private

    def extension_name
      extension.name
    end

    def supported?
      extension.supported?
    end

    def extension
      @extension ||= Catalog::Extension.from(object.name)
    end
  end
end
