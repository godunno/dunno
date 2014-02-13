# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "First class"
    start_at "2014-02-05 16:00:01"
    status "scheduled"
    teacher
  end
end
