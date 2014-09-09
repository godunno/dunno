class TopicBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(topic, :uuid, :description, :order)
  end
end
