FactoryGirl.define do
  factory :membership do
    profile
    course
    role 'student'

    factory :teacher_membership do
      role 'teacher'
    end
  end
end
