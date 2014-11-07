module Form
  class PersonalNoteForm < Form::Base
    model_class ::PersonalNote

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
        model.event = event
        model.done = done
        model.media = media
        model.save!
      end
  end
end
