# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teacher do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.base64(8) }
  end
end
