require 'spec_helper'

describe Membership do
  describe "associations" do
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to belong_to(:course) }
  end

  describe "validations" do
    let(:course) { create(:course) }
    let(:profile) { create(:profile) }

    it "doesn't allow associate the same profile to the same course more than once" do
      expect do
        Membership.create!(course: course, profile: profile, role: 'student')
      end.not_to raise_error

      expect do
        Membership.create!(course: course, profile: profile, role: 'student')
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end

    %w(profile role).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    it "allows to block student" do
      membership = Membership.create! course: course,
                                      profile: profile,
                                      role: 'student'
      membership.update(role: 'blocked')
      expect(membership).to be_valid
    end

    it "doesn't allow to block teacher" do
      membership = Membership.create! course: course,
                                      profile: profile,
                                      role: 'teacher'
      membership.update(role: 'blocked')
      expect(membership).not_to be_valid
      expect(membership.errors.details).to include(role: [error: :is_teacher])
    end

    it "only accepts valid role values" do
      is_expected.to validate_inclusion_of(:role).in_array(%w(student teacher blocked))
    end

    it "doesn't allow to turn teacher to student" do
      membership = Membership.create! course: course,
                                      profile: profile,
                                      role: 'teacher'
      membership.update(role: 'student')
      expect(membership).not_to be_valid
      expect(membership.errors.details).to include(role: [error: :is_teacher])
    end
  end

  describe "scopes" do
    describe ".as_teacher" do
      let!(:membership) { create(:membership) }
      let!(:membership_as_teacher) { create(:teacher_membership) }

      it { expect(Membership.as_teacher).to include membership_as_teacher }
      it { expect(Membership.as_teacher).to_not include membership }
    end
  end
end
