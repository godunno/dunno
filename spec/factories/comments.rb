FactoryGirl.define do
  factory :comment do
    body "This is awesome!"
    profile
    event

    trait :removed do
      removed_at Time.current
    end

    trait :blocked do
      blocked_at Time.current
    end
  end
end
