# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weekly_schedule do
    weekday 1
    start_time "MyString"
    end_time "MyString"
    course nil
  end
end
