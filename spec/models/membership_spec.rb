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
        Membership.create!(course: course, profile: profile, role: 'some role')
      end.not_to raise_error

      expect do
        Membership.create!(course: course, profile: profile, role: 'another role')
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end

    %w(profile role).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
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
