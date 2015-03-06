require_relative 'image_extractor'
require_relative 'extension_extractor'
require_relative 'media_thumbnail_wrapper'
require 'action_controller'

module Catalog
  class ThumbnailExtractor
    attr_reader :media

    def initialize(media)
      @media = media
    end

    def extract
      from_image || from_preview || from_extension || default
    end

    private

    def from_image
      ImageExtractor.extract(wrapped_media)
    end

    def from_preview
      media.preview.images.first.src.to_s
    rescue NoMethodError
      nil
    end

    def from_extension
      extension = ExtensionExtractor.extract(wrapped_media)
      extension ? asset_path(extension) : nil
    end

    def default
      asset_path(wrapped_media.file? ? :file : :url)
    end

    def wrapped_media
      MediaThumbnailWrapper.new(media)
    end

    def asset_path(file)
      ActionController::Base.helpers.asset_path("thumbnails/#{file}.png")
    end
  end
end
