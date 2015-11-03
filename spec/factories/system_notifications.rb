FactoryGirl.define do
  factory :system_notification do
    author { create(:profile) }
    profile

    trait :event_canceled do
      notifiable { create(:event) }
      notification_type :event_canceled
    end

    trait :event_published do
      notifiable { create(:event) }
      notification_type :event_published
    end

    trait :new_comment do
      notifiable { create(:comment) }
      notification_type :new_comment
    end

    trait :blocked do
      notifiable { create(:course) }
      notification_type :blocked
    end
  end
end
