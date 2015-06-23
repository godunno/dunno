# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "Português Bolado"
    start_date { Date.today }
    end_date { Date.tomorrow }
    class_name "101"
    institution "PUC-Rio"
    teacher { build(:profile) }
  end
end
