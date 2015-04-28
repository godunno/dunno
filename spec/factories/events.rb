# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    start_at { Time.zone.now.change(usec: 0) }
    end_at { 1.hour.from_now.change(usec: 0) }
    course
  end
end
