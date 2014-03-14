# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :personal_note do
    content "MyString"
    done false
    event nil
  end
end
