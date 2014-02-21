# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development? || Rails.env.staging?
  if Organization.count.zero?
    org = Organization.new(name: "Dunno Test")
    org.save!

    Student.create(name: "John Doe", email: "dow@dunno.vc", authentication_token: "svyZww54cxoE3nE8Hqgo", avatar: "http://lorempixel.com/100/100/people/", password: "#dunnovc", password_confirmation: "#dunnovc", organization: org)

    teacher = Teacher.new(name: "Prof. Example", email: "prof@dunno.vc", password: "#dunnovc", password_confirmation: "#dunnovc")
    teacher.organizations << org

    if Event.count.zero?
      Event.new(title: "1st class",start_at: 1.days.from_now, teacher: teacher, organization: org, status: "available").save!
      Event.new(title: "2nd class",start_at: 3.days.from_now, teacher: teacher, organization: org, status: "available").save!
      Event.new(title: "3th class",start_at: 5.days.from_now, teacher: teacher, organization: org, status: "available").save!
      Event.new(title: "4th class",start_at: 7.days.from_now, teacher: teacher, organization: org, status: "available").save!
      Event.new(title: "5th class",start_at: 9.days.from_now, teacher: teacher, organization: org, status: "available").save!


      Topic.new(description: "Machine Learning", event: Event.first).save!
      Topic.new(description: "AI", event: Event.first).save!
      Topic.new(description: "Visual Computing", event: Event.first).save!
    end
  end
end
