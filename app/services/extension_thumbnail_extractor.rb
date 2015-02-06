class ExtensionThumbnailExtractor
  SUPPORTED_EXTENSIONS = %w(doc)
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def extract
    extension = File.extname(name).sub('.', '')
    fail "Unsupported extension: #{extension}" unless SUPPORTED_EXTENSIONS.include?(extension)
    path = ActionController::Base.helpers.asset_path("extensions/#{extension}.png")
    Thumbnail.new(extension, path)
  end

  class Thumbnail
    attr_accessor :extension, :path

    def initialize(extension, path)
      self.extension = extension
      self.path = path
    end
  end
end
