require 'spec_helper'
require 'pundit/rspec'

describe CoursePolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:blocked_student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student, blocked_student]) }

  before do
    blocked_student.block_in!(course)
  end

  subject { described_class }

  permissions :show? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :create? do
    it { is_expected.to permit(anyone, Course.new) }
  end

  permissions :update? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :destroy? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :register? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :unregister? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :search? do
    it { is_expected.not_to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :send_notification? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :block? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :unblock? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.not_to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end

  permissions :analytics? do
    it { is_expected.to permit(teacher, course) }
    it { is_expected.to permit(student, course) }
    it { is_expected.not_to permit(anyone, course) }
    it { is_expected.not_to permit(blocked_student, course) }
  end
end
