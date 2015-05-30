FactoryGirl.define do
  factory :membership do
    profile
    course
    role 'some role'

    factory :teacher_membership do
      role 'teacher'
    end

    factory :student_membership do
      role 'student'
    end
  end
end
