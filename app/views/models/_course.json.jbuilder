json.(course, :id, :name, :uuid, :start_date, :end_date,
      :start_time, :end_time, :classroom, :weekdays)

json.events course.events do |event|
  json.partial! 'models/event', event: event, show_course: false
end
