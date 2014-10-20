module Form
  class OptionForm < Form::Base
    model_class ::Option

    attr_accessor :poll

    attribute :content, String
    attribute :correct, Boolean

    def initialize(params)
      super(params.slice(*attributes_list(:content, :correct)))
    end

    private

      def persist!
        model.content = content
        model.correct = correct
        model.poll = poll
        model.save!
      end
  end
end
