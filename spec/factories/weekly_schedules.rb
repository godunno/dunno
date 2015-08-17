# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weekly_schedule do
    course
    weekday 1
    start_time "09:00"
    end_time "11:00"
  end
end
