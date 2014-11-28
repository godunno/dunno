json.medias @result.records do |media|
  MediaBuilder.new(media).build!(json)
end

json.next_page @result.next_page
json.current_page @result.current_page
json.previous_page @result.previous_page
