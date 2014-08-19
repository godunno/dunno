# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MyString"
    teacher
    start_date { Date.today }
    end_date { Date.tomorrow }
    class_name "Room 999"
    institution "PUC-Rio"
  end
end
