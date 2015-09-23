student = Profile.create!(user: User.new(
  name: "João da Silva",
  email: "joao@gmail.com",
  password: "#dunnovc",
  authentication_token: "svyZww54cxoE3nE8Hqgo"
))

teacher = Profile.create!(user: User.new(
  name: "Girafales",
  email: "prof@dunno.vc",
  password: "#dunnovc",
  authentication_token: "VfHCJUg1xTqhNPLyU5ym"
))

course = Form::CourseForm.create(
  name: "Programming I", class_name: "TR230", teacher: teacher,
  start_date: 1.month.ago, end_date: 3.months.from_now,
  weekly_schedules: [
    { weekday: 1, start_time: "09:00", end_time: "11:00" },
    { weekday: 3, start_time: "14:00", end_time: "16:00" }
  ]
)
course.update_attribute(:access_code, "5fd1")

course.add_student(student)

course.events.reload

e1, e2, e3, e4 = course.events[0..3]

Topic.new(description: "Machine Learning", order: 1, event: e1).save!
Topic.new(description: "AI", order: 2, event: e1).save!
Topic.new(description: "Visual Computing", order: 3, event: e1).save!
