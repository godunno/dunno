FactoryGirl.define do
  factory :tracking_event do
    profile
    course

    trait :course_accessed do
      event_type 'course_accessed'
      trackable { course }
    end

    trait :file_downloaded do
      event_type 'file_downloaded'
      trackable { create(:media_with_file) }
    end

    trait :url_clicked do
      event_type 'url_clicked'
      trackable { create(:media_with_url) }
    end

    trait :comment_created do
      event_type 'comment_created'
      trackable { create(:comment) }
    end
  end
end
