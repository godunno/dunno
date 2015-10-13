require 'spec_helper'
require 'pundit/rspec'

describe CommentPolicy do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:other_teacher) { create(:profile) }
  let(:event) { create(:event, course: course) }

  subject { described_class }

  permissions :create? do
    let(:comment) { build(:comment, event: event) }
    it { is_expected.to permit(teacher, comment) }
    it { is_expected.to permit(student, comment) }
    it { is_expected.not_to permit(anyone, comment) }
    it { is_expected.not_to permit(other_teacher, comment) }
  end
end
