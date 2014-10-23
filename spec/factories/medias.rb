# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :media do
    topic
    title "MyString"
    description "MyString"
    category Media::CATEGORIES.first
    url "http://www.example.com/media.jpg"
    file nil

    factory :media_with_file do
      url nil
      file Tempfile.new('test')
    end
  end
end
