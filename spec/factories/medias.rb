# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :media do
    title "MyString"
    description "MyString"
    category Media::IMAGE
    url "http://www.example.com/media.jpg"
    event nil
    file nil

    factory :media_with_file do
      url nil
      file Tempfile.new('test')
    end
  end
end
