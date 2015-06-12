require 'spec_helper'
require 'pundit/rspec'

describe CoursePolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }

  subject { described_class }

  permissions :show? do
    it { expect(subject).to permit(teacher, course) }
    it { expect(subject).to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end

  permissions :create? do
    it { expect(subject).to permit(anyone, Course.new(teacher: anyone)) }
    it { expect(subject).not_to permit(anyone, Course.new(teacher: teacher)) }
  end

  permissions :update? do
    it { expect(subject).to permit(teacher, course) }
    it { expect(subject).not_to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end

  permissions :destroy? do
    it { expect(subject).to permit(teacher, course) }
    it { expect(subject).not_to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end

  permissions :register? do
    it { expect(subject).not_to permit(teacher, course) }
    it { expect(subject).not_to permit(student, course) }
    it { expect(subject).to permit(anyone, course) }
  end

  permissions :unregister? do
    it { expect(subject).not_to permit(teacher, course) }
    it { expect(subject).to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end

  permissions :students? do
    it { expect(subject).to permit(teacher, course) }
    it { expect(subject).to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end

  permissions :search? do
    it { expect(subject).not_to permit(teacher, course) }
    it { expect(subject).not_to permit(student, course) }
    it { expect(subject).to permit(anyone, course) }
  end

  permissions :send_notification? do
    it { expect(subject).to permit(teacher, course) }
    it { expect(subject).not_to permit(student, course) }
    it { expect(subject).not_to permit(anyone, course) }
  end
end
