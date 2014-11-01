object false

child @courses do
  attributes :id, :start_date, :end_date, :name, :institution, :class_name
  node(:links) do |course|
    {
      href: api_v2_course_events_url(course)
    }
  end
end
