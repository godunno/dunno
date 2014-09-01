class PollBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(poll, :uuid, :content, :status)
    json.released_at(format_time(poll.released_at))

    json.options poll.options do |option|
      OptionBuilder.new(option).build!(json)
    end
  end
end
