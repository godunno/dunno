module Form
  class MediaForm < Form::Base
    model_class ::Media

    attr_accessor :teacher

    attribute :title, String
    attribute :description, String
    attribute :category, String
    attribute :url, String
    attribute :file, String
    attribute :preview, Hash
    attribute :tag_list, String

    validates :url, format: URI.regexp(:http), allow_blank: true
    validate :mutually_exclusive_url_or_file

    def initialize(params)
      super(params.slice(*attributes_list(:title, :description, :category, :url, :file, :tag_list)))
      self.preview = LinkThumbnailer.generate(url).to_json if url.present?
    end

    private

    def persist!
      model.title       = title
      model.description = description
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
