module Form
  class ThermometerForm < Form::ArtifactForm
    model_class ::Thermometer

    attribute :content, String

    def initialize(params)
      super(params.slice(*attributes_list(:content)))
    end

    private

      def persist!
        super
        model.content = content
        model.save!
      end
  end
end
