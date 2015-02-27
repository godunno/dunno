require './app/services/aws_file'

module Catalog
  class MediaThumbnailWrapper
    attr_reader :thumbnail_source, :media

    def initialize(media)
      @media = media
      @thumbnail_source = media.url || (media.file ? AwsFile.new(media.file) : nil)
    end

    def name
      file? ? media.original_filename : thumbnail_source
    end

    def path
      file? ? thumbnail_source.url : thumbnail_source
    end

    def file?
      thumbnail_source.respond_to?(:url)
    end
  end
end
