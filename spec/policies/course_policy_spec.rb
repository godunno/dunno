require 'spec_helper'
require 'pundit/rspec'

describe CoursePolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }

  subject { described_class }

  permissions :show? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
  end

  permissions :create? do
    it { is_expected.to permit(anyone, Course.new(teacher: anyone)) }
    it { is_expected.not_to permit(anyone, Course.new(teacher: teacher)) }
  end

  permissions :update? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
  end

  permissions :destroy? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
  end

  permissions :register? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.to permit(anyone, course) }
  end

  permissions :unregister? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
  end

  permissions :search? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.to permit(anyone, course) }
  end

  permissions :send_notification? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
  end
end
