require 'database_cleaner'

if Rails.env.development? || Rails.env.staging?

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  org = Organization.new(name: "Dunno Test")
  org.save!
  org.update_attribute(:uuid, "65bcc7ce-0ea0-44cd-8d9d-74a43ac02e3d")

  student = Student.create(name: "John Doe", email: "dow@dunno.vc", authentication_token: "svyZww54cxoE3nE8Hqgo", avatar: "http://lorempixel.com/100/100/people/", password: "#dunnovc", password_confirmation: "#dunnovc")

  Teacher.create!(
    name: "Lucas Boscacci", email: "lucasboscacci@gmail.com", 
    password: "MatteoLucas", phone_number: "+55 21 99999 9999",
    avatar: "http://lorempixel.com/100/100/people/"
  )

  teacher = Teacher.create!(
    authentication_token: "VfHCJUg1xTqhNPLyU5ym",
    name: "Prof. Example", email: "prof@dunno.vc",
    password: "#dunnovc", phone_number: "+55 21 99999 9999",
    avatar: "http://lorempixel.com/100/100/people/"
  )
  teacher.organizations << org

  Student.create!(
    name: "João da Silva", email: "joao@gmail.com",
    password: "#dunnovc", phone_number: "+55 21 99999 9999"
  )

  course = Form::CourseForm.create(
    name: "Programming I", class_name: "TR230", teacher: teacher,
    start_date: 1.month.ago, end_date: 3.months.from_now,
    weekly_schedules: [
      { weekday: 1, start_time: "09:00", end_time: "11:00" },
      { weekday: 3, start_time: "14:00", end_time: "16:00" }
    ]
  )
  course.update_attribute(:access_code, "5fd1")

  student.courses << course
  student.save

  CourseScheduler.new(course).schedule!

  course.events.reload

  e1, e2, e3, e4 = course.events[0..3]

  Thermometer.new(content: "lineaer algebra", timeline: e1.timeline).save!
  Thermometer.new(content: "big data - data science", timeline: e1.timeline).save!
  o1 = Option.new(content: "jiban")
  o2 = Option.new(content: "jyraia")
  Poll.create!(content: "what do you watched on Manchete channel?", options: [o1, o2], timeline: e1.timeline, status: "available")
  Media.create!(timeline: e1.timeline, title: 'LOLCAT VIDEO', category: 'video', url: 'http://www.youtube.com/watch?v=0000000000')
  #Media.create!(event: e, title: 'LOLCAT IMAGE', category: 'image', file: Tempfile.new('cat.jpg'))

  Topic.new(description: "Machine Learning", timeline: e1.timeline).save!
  Topic.new(description: "AI", timeline: e1.timeline).save!
  Topic.new(description: "Visual Computing", timeline: e1.timeline).save!

  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e3.timeline, status: "available")
  Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e4.timeline, status: "available")

end
