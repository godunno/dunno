# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :poll do
    content "MyString"
    event
    status 'available'
  end
end
