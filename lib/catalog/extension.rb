module Catalog
  class Extension
    SUPPORTED_IMAGE_EXTENSIONS = %w(jpg jpeg png svg gif)
    SUPPORTED_FILE_EXTENSIONS = %w(doc docx ppt pptx xls xlsx ppt pptx pdf html txt rtf key pages numbers)
    SUPPORTED_EXTENSIONS = SUPPORTED_IMAGE_EXTENSIONS + SUPPORTED_FILE_EXTENSIONS

    def self.from(name)
      new(name)
    end

    def initialize(name)
      @name = name
    end

    def name
      File.extname(URI.parse(@name).path).sub('.', '').downcase rescue nil
    end

    def image?
      SUPPORTED_IMAGE_EXTENSIONS.include?(name)
    end

    def supported?
      SUPPORTED_EXTENSIONS.include?(name)
    end
  end
end
