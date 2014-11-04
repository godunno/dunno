module Form
  class TopicForm < Form::Base
    model_class ::Topic

    attr_accessor :event
    attr_accessor :media

    attribute :description, String
    attribute :order, Integer
    attribute :done, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:description, :order, :done)))
      self.media = Media.find_by(uuid: params[:media_id])
    end

    private

      def persist!
        model.description = description
        model.order = order
        model.done = done
        model.event = event
        model.media = media
        model.save!
      end
  end
end
