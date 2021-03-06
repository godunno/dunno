module Form
  class TopicForm < Form::Base
    model_class ::Topic

    attr_accessor :event
    attr_accessor :media

    attribute :description, String
    attribute :order, Integer
    attribute :done, Boolean
    attribute :personal, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:description, :order, :done, :personal)))
      self.media = Media.find_by(uuid: params[:media_id])
      if media.present?
        media.title = description if description.present?
        self.description = nil
      end
    end

    private

      def persist!
        model.description = description
        model.order       = order
        model.done        = done
        model.personal    = personal
        model.event       = event
        media.try(:save!)
        model.media       = media
        model.save!
      end
  end
end
