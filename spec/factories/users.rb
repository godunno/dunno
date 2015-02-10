# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    sequence(:phone_number, 1000) { |n| "+55 21 9999 #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { SecureRandom.base64(8) }

    trait :teacher_profile do
      association :profile, factory: :teacher
    end
    trait :with_api_key do
      after(:create) do |user|
        FactoryGirl.create(:api_key, user: user)
      end
    end
  end
end
