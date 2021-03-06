module Catalog
  class Extension
    SUPPORTED_IMAGE_EXTENSIONS = %w(jpg jpeg png svg gif)
    SUPPORTED_FILE_EXTENSIONS = %w(doc docx ppt pptx xls xlsx ppt pptx pdf html txt rtf key pages numbers)
    SUPPORTED_EXTENSIONS = SUPPORTED_IMAGE_EXTENSIONS + SUPPORTED_FILE_EXTENSIONS
    URL_REGEX = /\A#{URI.regexp(%w(http https))}\z/

    def self.from(name)
      new(name)
    end

    def initialize(name)
      @name = name
    end

    def name
      return nil if @name.nil?

      File.extname(filename).gsub('.', '').downcase
    end

    def image?
      SUPPORTED_IMAGE_EXTENSIONS.include?(name)
    end

    def supported?
      SUPPORTED_FILE_EXTENSIONS.include?(name)
    end

    private

    def url?
      @name =~ URL_REGEX
    end

    def filename
      url? ? URI.parse(@name).path : @name
    end
  end
end
