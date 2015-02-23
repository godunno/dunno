student = Student.create!(user: User.new(
  name: "João da Silva",
  email: "joao@gmail.com",
  password: "#dunnovc",
  phone_number: "+55 21 99999 9990",
  authentication_token: "svyZww54cxoE3nE8Hqgo"
))

Teacher.create!(user: User.new(
  name: "Lucas Boscacci",
  email: "lucasboscacci@gmail.com",
  password: "MatteoLucas",
  phone_number: "+55 21 99999 9991"
))

teacher = Teacher.create!(user: User.new(
  name: "Girafales",
  email: "prof@dunno.vc",
  password: "#dunnovc",
  phone_number: "+55 21 99999 9992",
  authentication_token: "VfHCJUg1xTqhNPLyU5ym"
))

org = Organization.new(name: "Dunno Test")
org.save!
org.update_attribute(:uuid, "65bcc7ce-0ea0-44cd-8d9d-74a43ac02e3d")

teacher.organizations << org

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

Topic.new(description: "Machine Learning", order: 1, event: e1).save!
Topic.new(description: "AI", order: 2, event: e1).save!
Topic.new(description: "Visual Computing", order: 3, event: e1).save!

Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e2.timeline, status: "available")
Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e3.timeline, status: "available")
Poll.create!(content: "What did you watch on Manchete channel?", options: [Option.new(content: "fake"),Option.new(content: "fake2")], timeline: e4.timeline, status: "available")
