# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.base64(8) }
    password_confirmation { |u| u.password }
    organization
  end
end
