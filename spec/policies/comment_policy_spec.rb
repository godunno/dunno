require 'spec_helper'
require 'pundit/rspec'

describe CommentPolicy do
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
  let(:other_teacher) { create(:profile) }
  let(:event) { create(:event, course: course) }

  subject { described_class }

  permissions :create? do
    let(:comment) { build(:comment, event: event) }

    it { is_expected.to permit(teacher, comment) }
    it { is_expected.to permit(student, comment) }
    it { is_expected.to permit(moderator, comment) }
    it { is_expected.not_to permit(anyone, comment) }
    it { is_expected.not_to permit(other_teacher, comment) }

    context "commenting on a non-scheduled event" do
      let(:event) { build(:event, start_at: Time.zone.parse('2015-10-18 17:53'), course: course) }
      let(:comment) { build(:comment, event: event) }

      it { is_expected.to permit(teacher, comment) }
      it { is_expected.to permit(moderator, comment) }
      it { is_expected.not_to permit(student, comment) }

      it "allows to comment on the event if it was already created" do
        event.save!
        is_expected.to permit(student, comment)
      end
    end
  end

  permissions :destroy? do
    let(:comment) { create(:comment) }
    let(:blocked_comment) { create(:comment, :blocked) }

    it { is_expected.to permit(comment.profile, comment) }
    it { is_expected.not_to permit(anyone, comment) }

    it "doesn't allow to remove blocked comments" do
      is_expected.not_to permit(blocked_comment.profile, blocked_comment)
    end
  end

  permissions :restore? do
    let(:removed_comment) { create(:comment, :removed) }

    it { is_expected.to permit(removed_comment.profile, removed_comment) }
    it { is_expected.not_to permit(anyone, removed_comment) }
  end

  permissions :block? do
    let(:comment) { create(:comment, event: event) }
    let(:removed_comment) { create(:comment, :removed, event: event) }
    let(:teacher_comment) { create(:comment, event: event, profile: teacher) }

    it { is_expected.to permit(teacher, comment) }
    it { is_expected.to permit(moderator, comment) }
    it { is_expected.not_to permit(comment.profile, comment) }
    it { is_expected.not_to permit(student, comment) }
    it { is_expected.not_to permit(anyone, comment) }

    it "doesn't allow to block removed comments" do
      is_expected.not_to permit(teacher, removed_comment)
    end

    it "doesn't allow the teacher to block its own comment" do
      is_expected.not_to permit(teacher, teacher_comment)
    end
  end

  permissions :unblock? do
    let(:comment) { create(:comment, event: event) }

    it { is_expected.to permit(teacher, comment) }
    it { is_expected.to permit(moderator, comment) }
    it { is_expected.not_to permit(comment.profile, comment) }
    it { is_expected.not_to permit(student, comment) }
    it { is_expected.not_to permit(anyone, comment) }
  end

  permissions :show? do
    context "public comment" do
      let(:comment) { create(:comment, event: event) }

      it { is_expected.to permit(teacher, comment) }
      it { is_expected.to permit(moderator, comment) }
      it { is_expected.to permit(student, comment) }
      it { is_expected.not_to permit(anyone, comment) }
    end

    context "removed comment" do
      let(:removed_comment) { create(:comment, :removed, event: event) }

      it { is_expected.not_to permit(teacher, removed_comment) }
      it { is_expected.not_to permit(moderator, removed_comment) }
      it { is_expected.not_to permit(removed_comment.profile, removed_comment) }
      it { is_expected.not_to permit(student, removed_comment) }
      it { is_expected.not_to permit(anyone, removed_comment) }
    end

    context "blocked comment" do
      let(:blocked_comment) { create(:comment, :blocked, event: event) }

      it { is_expected.to permit(teacher, blocked_comment) }
      it { is_expected.to permit(moderator, blocked_comment) }
      it { is_expected.not_to permit(blocked_comment.profile, blocked_comment) }
      it { is_expected.not_to permit(student, blocked_comment) }
      it { is_expected.not_to permit(anyone, blocked_comment) }
    end
  end
end
