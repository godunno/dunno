# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    start_at "2014-02-05 16:00:01"
    end_at   "2014-02-05 18:00:01"
    timeline
    course
  end
end
