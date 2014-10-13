module Form
  class TopicForm < Form::ArtifactForm

    model_class ::Topic

    attribute :description, String
    attribute :order, Integer
    attribute :done, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:description, :order, :done)))
    end

    private

      def persist!
        super
        model.description = description
        model.order = order
        model.done = done
        model.save!
      end
  end
end
