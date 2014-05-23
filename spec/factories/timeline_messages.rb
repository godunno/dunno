# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline_message do
    content "I really like that"
    student
  end
end
