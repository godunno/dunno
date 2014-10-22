module Form
  class TopicForm < Form::Base
    model_class ::Topic

    attr_accessor :event
    attribute :description, String
    attribute :order, Integer
    attribute :done, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:description, :order, :done)))
    end

    private

      def persist!
        model.description = description
        model.order = order
        model.done = done
        model.event = event
        model.save!
      end
  end
end
