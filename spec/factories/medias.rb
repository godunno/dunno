# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :media do
    title "Title"
    association :mediable, factory: :topic

    factory :media_with_url do
      file_url nil
      url "http://mussumipsum.com/"
    end

    factory :media_with_file do
      url nil
      sequence(:file_url) { |n| "uploads/#{n}_document.doc" }
      original_filename "document.doc"
    end
  end
end
