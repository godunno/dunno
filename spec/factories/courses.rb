# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MyString"
    teacher
    weekdays [:monday]
    start_date { Date.today }
    end_date { Date.tomorrow }
    start_time "14:00"
    end_time "16:00"
  end
end
