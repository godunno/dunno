# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :thermometer do
    timeline
    content "MyString"
  end
end
