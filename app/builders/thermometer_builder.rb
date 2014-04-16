class ThermometerBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(thermometer, :uuid, :content)
  end
end
