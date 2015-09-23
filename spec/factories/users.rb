# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Test User ##{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { SecureRandom.base64(8) }

    trait :teacher_profile do
      association :profile, factory: :profile
    end
    trait :with_api_key do
      after(:create) do |user|
        FactoryGirl.create(:api_key, user: user)
      end
    end
  end
end
