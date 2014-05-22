# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :poll do
    timeline
    content "MyString"
    status 'available'
  end
end
