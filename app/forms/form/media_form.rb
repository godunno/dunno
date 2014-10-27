module Form
  class MediaForm < Form::Base
    model_class ::Media

    attribute :title, String
    attribute :description, String
    attribute :category, String
    attribute :url, String
    attribute :file, String

    validates :url, format: URI.regexp(:http), allow_blank: true
    validate :mutually_exclusive_url_or_file

    def initialize(params)
      super(params.slice(*attributes_list(:title, :description, :category, :url, :file)))
    end

    private

    def persist!
      model.title       = title
      model.description = description
      model.category    = category
      model.url         = url
      model.file        = file
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
