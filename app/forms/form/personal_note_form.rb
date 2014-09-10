module Form
  class PersonalNoteForm < Form::Base

    model_class ::PersonalNote

    attr_accessor :event

    attribute :content, String
    attribute :order, Integer

    def initialize(params)
      super(params.slice(*attributes_list(:content, :order)))
    end

    private

      def persist!
        model.content = content
        model.order = order
        model.event = event
        model.save!
      end
  end
end
