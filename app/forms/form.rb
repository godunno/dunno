module Form
  class Base
    include Virtus.model
    include ActiveModel::Model

    def self.model_class(model_class)
      define_method :model_class do
        model_class
      end
    end

    attr_reader :model
    attribute :_destroy, Boolean

    def initialize(attributes)
      attributes = attributes.with_indifferent_access
      id = attributes.delete(:id)
      super(attributes)
      @model = find_or_instantiate(id)
    end

    def save
      if _destroy
        model.destroy
      elsif valid?
        persist!
        true
      else
        false
      end
    end

    def persist!
      raise NotImplementedError
    end

    private

      def find_or_instantiate(id)
        if id.present?
          model_class.find(id)
        else
          model_class.new
        end
      end

    protected

      def attributes_list(*list)
        [:id, :_destroy] + list
      end

      def populate_children(form, models)
        models ||= []
        models.map { |model| form.new(model) }
      end
  end
end
