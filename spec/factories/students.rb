# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    sequence(:email) { |n| "user#{n}@gmail.com" };
    password "thatsecret"
    password_confirmation { |u| u.password }
    organization
  end
end
