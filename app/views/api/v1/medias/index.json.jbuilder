json.medias @result.records do |media|
  MediaBuilder.new(media).build!(json, show_events: true)
end

json.next_page @result.next_page
json.current_page @result.current_page
json.previous_page @result.previous_page
