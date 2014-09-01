# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    phone_number { "+55 21 9999 #{rand(9999).to_s.rjust(4, '9')}" }
    email { Faker::Internet.email }
    password { SecureRandom.base64(8) }
  end
end
