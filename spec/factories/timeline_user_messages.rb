# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline_user_message do
    content "I am really liking this"
    timeline
  end
end
