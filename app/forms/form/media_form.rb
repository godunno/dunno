module Form
  class MediaForm < Form::Base
    MAX_CHARS = 255

    model_class ::Media

    attr_accessor :teacher, :preview

    attribute :title, String
    attribute :description, String
    attribute :thumbnail, String
    attribute :category, String
    attribute :url, String
    attribute :file_url, String
    attribute :original_filename, String
    attribute :tag_list, String

    validates :url, format: URI.regexp(%w(http https)), allow_blank: true
    validate :mutually_exclusive_url_or_file

    def initialize(params)
      super(params.slice(*attributes_list(:title, :description, :category, :url, :file_url, :original_filename, :tag_list)))
      set_preview!
      self.title = preview.title
      self.description = preview.description.try(:truncate, MAX_CHARS)
      set_thumbnail!
    end

    private

    def persist!
      model.title             = title
      model.description       = description
      model.thumbnail         = thumbnail
      model.category          = category
      model.url               = url
      model.file_url          = file_url
      model.original_filename = original_filename
      model.preview           = preview.as_json
      model.tag_list          = tag_list
      model.teacher           = teacher
      model.save!
    end

    def mutually_exclusive_url_or_file
      url_present, file_present = url.present?, file_url.present?
      %w(url file_url).each do |attribute|
        if !url_present && !file_present
          errors.add(attribute, :blank)
        elsif url_present && file_present
          errors.add(attribute, :invalid)
        end
      end
    end

    def set_preview!
      if url.present?
        self.url = "http://#{url}" unless URI.parse(url).scheme.present? rescue url
        self.preview = LinkThumbnailerWrapper.generate(url)
      elsif original_filename.present?
        self.preview = Hashie::Mash.new(title: original_filename)
      elsif file_url.present?
        self.preview = Hashie::Mash.new(title: file_url)
      else
        self.preview = Hashie::Mash.new
      end
    end

    def set_thumbnail!
      self.thumbnail = Catalog::ThumbnailExtractor.new(self).extract
    end
  end
end
