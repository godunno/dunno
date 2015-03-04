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
      is_uri = @name =~ /\A#{URI.regexp(%w(http https))}\z/
      path_to_extract = is_uri ? URI.parse(@name).path : @name
      File.extname(path_to_extract).gsub('.', '').downcase rescue nil
    end

    def image?
      SUPPORTED_IMAGE_EXTENSIONS.include?(name)
    end

    def supported?
      SUPPORTED_FILE_EXTENSIONS.include?(name)
    end
  end
end
