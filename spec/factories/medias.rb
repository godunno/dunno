# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :media do
    title "MyString"
    description "MyString"
    category Media::IMAGE
    url "http://www.example.com/media.jpg"
    event nil
  end
end
