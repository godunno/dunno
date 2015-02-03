module Form
  class MediaForm < Form::Base
    MAX_CHARS = 255

    model_class ::Media

    attr_accessor :teacher

    attribute :title, String
    attribute :description, String
    attribute :thumbnail, String
    attribute :category, String
    attribute :url, String
    attribute :file, String
    attribute :preview, Hash
    attribute :tag_list, String

    validates :url, format: URI.regexp(%w(http https)), allow_blank: true
    validate :mutually_exclusive_url_or_file

    def initialize(params)
      super(params.slice(*attributes_list(:title, :description, :category, :url, :file, :tag_list)))
      if url.present?
        self.url = "http://#{url}" unless URI.parse(url).scheme.present? rescue url
        self.preview = LinkThumbnailer.generate(url).as_json
        self.title = preview[:title]
        self.description = preview[:description].truncate(MAX_CHARS)
        self.thumbnail = preview[:images][0].try(:src).try(:to_s)
      elsif file.present?
        self.title = file.original_filename
      end
    end

    private

    def persist!
      model.title       = title
      model.description = description
      model.thumbnail   = thumbnail
      model.category    = category
      model.url         = url
      model.file        = file
      model.preview     = preview
      model.tag_list    = tag_list
      model.teacher     = teacher
      model.save!
    end

    def mutually_exclusive_url_or_file
      url_present, file_present = url.present?, file.try(:original_filename).present?
      %w(url file).each do |attribute|
        if !url_present && !file_present
          errors.add(attribute, :blank)
        elsif url_present && file_present
          errors.add(attribute, :invalid)
        end
      end
    end
  end
end
