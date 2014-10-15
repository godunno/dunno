module Form
  class PersonalNoteForm < Form::Base
    model_class ::PersonalNote

    attr_accessor :event

    attribute :content, String
    attribute :order, Integer
    attribute :done, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:content, :order, :done)))
    end

    private

      def persist!
        model.content = content
        model.order = order
        model.event = event
        model.done = done
        model.save!
      end
  end
end
