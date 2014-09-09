module Form
  class TopicForm < Form::ArtifactForm

    model_class ::Topic

    attribute :description, String
    attribute :order, Integer

    def initialize(params)
      super(params.slice(*attributes_list(:description, :order)))
    end

    private

      def persist!
        super
        model.description = description
        model.order = order
        model.save!
      end
  end
end
