FactoryGirl.define do
  factory :system_notification do
    author { create(:profile) }
    profile

    trait :event_canceled do
      notifiable { create(:event) }
      notification_type :event_canceled
    end
  end
end
