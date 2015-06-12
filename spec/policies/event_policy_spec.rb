require 'spec_helper'
require 'pundit/rspec'

describe EventPolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:event) { create(:event, course: course) }

  subject { described_class }

  permissions :show? do
    it { expect(subject).to permit(teacher, event) }
    it { expect(subject).to permit(student, event) }
    it { expect(subject).not_to permit(anyone, event) }
  end

  permissions :create? do
    it { expect(subject).to permit(teacher, event) }
    it { expect(subject).not_to permit(student, event) }
    it { expect(subject).not_to permit(anyone, event) }
  end

  permissions :update? do
    it { expect(subject).to permit(teacher, event) }
    it { expect(subject).not_to permit(student, event) }
    it { expect(subject).not_to permit(anyone, event) }
  end
end
