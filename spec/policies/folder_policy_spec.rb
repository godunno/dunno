require 'spec_helper'
require 'pundit/rspec'

describe FolderPolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }

  subject { described_class }

  permissions :create? do
    let(:folder) { build(:folder, course: course) }

    it { is_expected.to permit(teacher, folder) }
    it { is_expected.not_to permit(student, folder) }
    it { is_expected.not_to permit(anyone, folder) }
  end

  permissions :destroy? do
    let(:folder) { create(:folder, course: course) }

    it { is_expected.to permit(teacher, folder) }
    it { is_expected.not_to permit(student, folder) }
    it { is_expected.not_to permit(anyone, folder) }
  end
end
