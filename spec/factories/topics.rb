# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    event
    description "MyString"

    trait :personal do
      personal true
    end
  end
end
