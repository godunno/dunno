namespace :courses do
  desc "Persist past events so they won't change with eventual changes in the course's weekly schedules"
  task persist_past_events: :environment do
    puts "Persisting events..."
    events_before = Event.count
    Course.find_each do |course|
      puts "for Course#id #{course.id}"
      PersistPastEvents.new(course).persist!
    end
    puts "Done!"
    events_count = Event.count - events_before
    puts "#{events_count} events persisted."
  end
end
