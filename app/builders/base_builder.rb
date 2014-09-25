class BaseBuilder

  attr_reader :object

  def initialize(object)
    attribute_name = object.class.name.underscore
    class_eval do
      attr_accessor attribute_name
    end
    send("#{attribute_name}=", object)
  end

  def build!(json, options = {})
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
