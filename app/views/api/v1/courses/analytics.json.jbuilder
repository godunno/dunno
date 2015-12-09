json.array! @members do |profile, tracking_events|
  json.(profile, :id, :name, :avatar_url)
  json.course_accessed_events tracking_events.select(&:course_accessed?).count
  json.file_downloaded_events tracking_events.select(&:file_downloaded?).count
  json.url_clicked_events tracking_events.select(&:url_clicked?).count
  json.comment_created_events tracking_events.select(&:comment_created?).count
end
