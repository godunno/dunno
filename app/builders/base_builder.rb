class BaseBuilder
  attr_reader :object

  def initialize(object)
    @object = object

    attribute_name = object.class.name.underscore
    class_eval do
      alias_method attribute_name, :object
    end
  end

  def build!(json, options = {})
    return unless object.present?
    build(json, options)
  end

  protected
    def build(json = Jbuilder.new, options = {})
      raise 'You should implement this method when subclassing.'
    end

    def format_time(time)
      time.try(:utc).try(:iso8601)
    end
end
