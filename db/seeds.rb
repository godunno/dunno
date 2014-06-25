require 'database_cleaner'

if Rails.env.development? || Rails.env.staging?

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  org = Organization.new(name: "Dunno Test")
  org.save!
  org.update_attribute(:uuid, "65bcc7ce-0ea0-44cd-8d9d-74a43ac02e3d")

  student = Student.create(name: "John Doe", email: "dow@dunno.vc", authentication_token: "svyZww54cxoE3nE8Hqgo", avatar: "http://lorempixel.com/100/100/people/", password: "#dunnovc", password_confirmation: "#dunnovc")

  Teacher.create!(name: "Lucas Boscacci", email: "lucasboscacci@gmail.com", password: "MatteoLucas", password_confirmation: "MatteoLucas", avatar: "http://lorempixel.com/100/100/people/")
  teacher = Teacher.new(authentication_token: "VfHCJUg1xTqhNPLyU5ym", name: "Prof. Example", email: "prof@dunno.vc", password: "#dunnovc", password_confirmation: "#dunnovc", avatar: "http://lorempixel.com/100/100/people/")
  teacher.organizations << org

  course = Course.new(name: "Programming I", teacher: teacher)
  course.weekdays = [2, 4]
  course.start_date = 1.day.ago
  course.start_time = "08:00"
  course.end_date = Time.now + 3.days
  course.end_time = "18:00"
  student.courses << course
  student.save

  e1 = Form::EventForm.create(title: "1st class",start_at: 1.days.from_now, duration: "2:00", status: "available", course: course)
  Thermometer.new(content: "lineaer algebra", timeline: e1.timeline).save!
  Thermometer.new(content: "big data - data science", timeline: e1.timeline).save!
  o1 = Option.new(content: "jiban")
  o2 = Option.new(content: "jyraia")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [o1, o2], timeline: e1.timeline, status: "available")
  Media.create!(timeline: e1.timeline, title: 'LOLCAT VIDEO', category: 'video', url: 'http://www.youtube.com/watch?v=0000000000')
  #Media.create!(event: e, title: 'LOLCAT IMAGE', category: 'image', file: Tempfile.new('cat.jpg'))

  e2 = Form::EventForm.create(title: "2nd class",start_at: 5.days.from_now, duration: "2:00", status: "available", course: course)
  e3 = Form::EventForm.create(title: "3th class",start_at: 7.days.from_now, duration: "2:00", status: "available", course: course)
  e4 = Form::EventForm.create(title: "4th class",start_at: 9.days.from_now, duration: "2:00", status: "available", course: course)

  Topic.new(description: "Machine Learning", timeline: e1.timeline).save!
  Topic.new(description: "AI", timeline: e1.timeline).save!
  Topic.new(description: "Visual Computing", timeline: e1.timeline).save!

  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e3.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e4.timeline, status: "available")

end
