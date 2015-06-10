object false

child @events do
  attributes :id, :start_at
  node(:status) do |event|
    event.formatted_status(current_profile)
  end
end
node(:prev) do
  api_v2_course_events_url(
    @course,
    month: 1.month.ago.month,
    year: 1.month.ago.year
  )
end
node(:next) do
  api_v2_course_events_url(
    @course,
    month: 1.month.from_now.month,
    year: 1.month.from_now.year
  )
end
