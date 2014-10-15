module Form
  class Base
    include Virtus.model
    include ActiveModel::Model

    RESERVED_ATTRIBUTES = [:uuid, :_destroy]

    def self.model_class(model_class)
      define_method :model_class do
        model_class
      end
    end

    attr_reader :model
    attribute :_destroy, Boolean

    def initialize(attributes)
      attributes = attributes.with_indifferent_access
      uuid = attributes.delete(:uuid)
      @model = find_or_instantiate(uuid)
      sync_from_model!
      super(attributes)
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

    def save!
      save || raise(ActiveRecord::RecordInvalid.new(model))
    end

    def self.create(*args)
      form = new(*args)
      form.save
      form.model
    end

    def persist!
      raise NotImplementedError
    end

    private

      def find_or_instantiate(uuid)
        if uuid.present?
          model_class.where(uuid: uuid).first
        else
          model_class.new
        end
      end

      def sync_from_model!
        self.attributes = model.attributes.with_indifferent_access
          .slice(*attributes.keys)
      end

    protected

      def attributes_list(*list)
        RESERVED_ATTRIBUTES + list
      end

      def populate_children(form, models)
        models ||= []
        models.map { |model| form.new(model) }
      end
  end
end
