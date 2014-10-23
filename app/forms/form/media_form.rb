module Form
  class MediaForm < Form::Base
    model_class ::Media

    attribute :title, String
    attribute :description, String
    attribute :category, String
    attribute :url, String
    attribute :file, String

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
  end
end
