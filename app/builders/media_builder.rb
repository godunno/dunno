class MediaBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(media, :id, :uuid, :title, :description, :category, :preview, :type, :thumbnail)
    json.filename(media.original_filename)

    # Necessary due to an error when serializing tags
    json.tag_list(media.tag_list.as_json)
    json.url(media.url)

    if options[:show_events]
      json.courses do
        json.array! media.events.group_by(&:course).to_a do |course, events|
          json.(course, :uuid, :name)
          json.events events do |event|
            json.(event, :uuid)
            json.start_at(format_time(event.start_at))
          end
        end
      end
    end
  end
end
