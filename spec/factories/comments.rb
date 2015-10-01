FactoryGirl.define do
  factory :comment do
    body "This is awesome!"
    user
    event
  end
end
