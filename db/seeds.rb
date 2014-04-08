require 'database_cleaner'

if Rails.env.development? || Rails.env.staging?

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean


  org = Organization.new(name: "Dunno Test")
  org.save!
  org.update_attribute(:uuid, "65bcc7ce-0ea0-44cd-8d9d-74a43ac02e3d")

  student = Student.create(name: "John Doe", email: "dow@dunno.vc", authentication_token: "svyZww54cxoE3nE8Hqgo", avatar: "http://lorempixel.com/100/100/people/", password: "#dunnovc", password_confirmation: "#dunnovc")

  teacher = Teacher.new(name: "Prof. Example", email: "prof@dunno.vc", password: "#dunnovc", password_confirmation: "#dunnovc", avatar: "http://lorempixel.com/100/100/people/")
  teacher.organizations << org

  course = Course.new(name: "Programming I", teacher: teacher)
  course.weekdays = [2, 4]
  course.start_date = 1.day.ago
  course.start_time = "08:00"
  course.end_date = Time.now + 3.days
  course.end_time = "18:00"
  student.courses << course
  student.save

  e = Event.create!(title: "1st class",start_at: 1.days.from_now, duration: "2:00", status: "opened", course: course)
  Thermometer.new(content: "lineaer algebra", event_id: e.id).save!
  Thermometer.new(content: "big data - data science", event_id: e.id).save!
  o1 = Option.new(content: "jiban")
  o2 = Option.new(content: "jyraia")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [o1, o2], event: e, status: "available")

  Event.new(title: "2nd class",start_at: 3.days.from_now, duration: "2:00", status: "available", course: course)
  e2 = Event.create!(title: "3th class",start_at: 5.days.from_now, duration: "2:00", status: "available", course: course)
  e3 = Event.create!(title: "4th class",start_at: 7.days.from_now, duration: "2:00", status: "opened", course: course)
  e4 = Event.create!(title: "5th class",start_at: 9.days.from_now, duration: "2:00", status: "available", course: course)

  Topic.new(description: "Machine Learning", event: Event.first).save!
  Topic.new(description: "AI", event: Event.first).save!
  Topic.new(description: "Visual Computing", event: Event.first).save!

  Poll.create!(content: "what do you watched on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], event: e2, status: "available")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], event: e2, status: "available")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], event: e3, status: "available")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], event: e4, status: "available")


end
