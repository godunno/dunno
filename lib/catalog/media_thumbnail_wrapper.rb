module Catalog
  class MediaThumbnailWrapper
    attr_reader :thumbnail_source, :name, :path

    def initialize(media)
      @thumbnail_source = media.url || media.file
    end

    def name
      file? ? thumbnail_source.original_filename : thumbnail_source
    end

    def path
      file? ? thumbnail_source.path : thumbnail_source
    end

    def file?
      thumbnail_source.respond_to?(:original_filename)
    end
  end
end
