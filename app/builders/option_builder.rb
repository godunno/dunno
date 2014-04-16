class OptionBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(option, :uuid, :content)
  end
end
