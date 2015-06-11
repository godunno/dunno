require 'spec_helper'

describe Membership, type: :model do
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
      end.to raise_error
    end

    %w(profile role).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end
end
