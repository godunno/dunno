require './app/services/aws_file'

module Catalog
  class MediaThumbnailWrapper
    attr_reader :thumbnail_source, :media

    def initialize(media)
      @media = media
      @thumbnail_source = media.url || media.file_url
    end

    def name
      file? ? media.original_filename : thumbnail_source
    end

    def path
      thumbnail_source
    end

    def file?
      !!media.file_url
    end
  end
end
