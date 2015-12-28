require 'spec_helper'
require 'pundit/rspec'

describe EventPolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:moderator) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) do
    create :course,
           teacher: teacher,
           students: [student],
           moderators: [moderator]
  end
  let(:event) { create(:event, course: course) }

  subject { described_class }

  permissions :show? do
    it { is_expected.to permit(teacher, event) }
    it { is_expected.to permit(moderator, event) }
    it { is_expected.to permit(student, event) }
    it { is_expected.not_to permit(anyone, event) }
  end

  permissions :create? do
    it { is_expected.to permit(teacher, event) }
    it { is_expected.to permit(moderator, event) }
    it { is_expected.not_to permit(student, event) }
    it { is_expected.not_to permit(anyone, event) }
  end

  permissions :update? do
    it { is_expected.to permit(teacher, event) }
    it { is_expected.to permit(moderator, event) }
    it { is_expected.not_to permit(student, event) }
    it { is_expected.not_to permit(anyone, event) }
  end
end
