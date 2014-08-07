# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MyString"
    teacher
    start_date { Date.today }
    end_date { Date.tomorrow }
  end
end
