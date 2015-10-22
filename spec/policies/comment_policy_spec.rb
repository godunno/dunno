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

    context "commenting on a non-scheduled event" do
      let(:event) { build(:event, start_at: Time.zone.parse('2015-10-18 17:53'), course: course) }
      let(:comment) { build(:comment, event: event) }

      it { is_expected.to permit(teacher, comment) }
      it { is_expected.not_to permit(student, comment) }

      it "allows to comment on the event if it was already created" do
        event.save!
        is_expected.to permit(student, comment)
      end
    end
  end
end
