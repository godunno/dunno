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

    trait :promoted_to_moderator do
      notifiable { create(:course) }
      notification_type :promoted_to_moderator 
    end

    trait :new_member do
      notifiable { create(:course) }
      notification_type :new_member
    end

    trait :new_topic do
      notifiable { create(:topic) }
      notification_type :new_topic
    end
  end
end
