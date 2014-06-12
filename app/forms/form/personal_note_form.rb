module Form
  class PersonalNoteForm < Form::Base

    model_class ::PersonalNote

    attr_accessor :event

    attribute :content, String

    def initialize(params)
      super(params.slice(*attributes_list(:content)))
    end

    private

      def persist!
        model.content = content
        model.event = event
        model.save!
      end
  end
end
