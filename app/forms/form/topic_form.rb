module Form
  class TopicForm < Form::ArtifactForm

    model_class ::Topic

    attribute :description, String

    def initialize(params)
      super(params.slice(*attributes_list(:description)))
    end

    private

      def persist!
        super
        model.description = description
        model.save!
      end
  end
end
