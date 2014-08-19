# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teacher do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone_number { "+55 21 99999 9999" }
    password { SecureRandom.base64(8) }
  end
end
