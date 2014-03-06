require 'database_cleaner'

if Rails.env.development? || Rails.env.staging?

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean


  org = Organization.new(name: "Dunno Test")
  org.save!
  org.update_attribute(:uuid, "65bcc7ce-0ea0-44cd-8d9d-74a43ac02e3d")

  Student.create(name: "John Doe", email: "dow@dunno.vc", authentication_token: "svyZww54cxoE3nE8Hqgo", avatar: "http://lorempixel.com/100/100/people/", password: "#dunnovc", password_confirmation: "#dunnovc", organization: org)

  teacher = Teacher.new(name: "Prof. Example", email: "prof@dunno.vc", password: "#dunnovc", password_confirmation: "#dunnovc", avatar: "http://lorempixel.com/100/100/people/")
  teacher.organizations << org

  Event.new(title: "1st class (opened)",start_at: 1.days.from_now, duration: "2:00", teacher: teacher, organization: org, status: "opened").save!
  Event.new(title: "2nd class",start_at: 3.days.from_now, duration: "2:00", teacher: teacher, organization: org, status: "available").save!
  Event.new(title: "3th class",start_at: 5.days.from_now, duration: "2:00", teacher: teacher, organization: org, status: "available").save!
  Event.new(title: "4th class (opened)",start_at: 7.days.from_now, duration: "2:00", teacher: teacher, organization: org, status: "opened").save!
  Event.new(title: "5th class",start_at: 9.days.from_now, duration: "2:00", teacher: teacher, organization: org, status: "available").save!

  Topic.new(description: "Machine Learning", event: Event.first).save!
  Topic.new(description: "AI", event: Event.first).save!
  Topic.new(description: "Visual Computing", event: Event.first).save!

end
