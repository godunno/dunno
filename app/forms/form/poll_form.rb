module Form
  class PollForm < Form::ArtifactForm

    model_class ::Poll

    attribute :content, String

    def initialize(params)
      super(params.slice(*attributes_list(:content)))
      @options = populate_children(Form::OptionForm, params[:options])
      @options.each { |option| option.poll = model }
    end

    def valid?
      result = super
      [@options].each do |associates|
        associates.each do |associated|
          result &&= associated.valid?
        end
      end
      result
    end

    def errors
      result = super
      @options.each do |option|
        option.errors.each { |error, message| result.add error, message }
      end
      result
    end

    private

      def persist!
        super
        ActiveRecord::Base.transaction do
          model.content = content
          @options.each do |option|
            option.save
          end
          model.save!
        end
      end
  end
end
