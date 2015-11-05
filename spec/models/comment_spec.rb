require 'spec_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build(:comment) }

  describe "associations" do
    it { is_expected.to belong_to :profile }
    it { is_expected.to belong_to :event }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:profile) }
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe "#event_start_at" do
    let(:comment) { create(:comment) }

    it { expect(comment.event_start_at).to eq comment.event.start_at }
  end

  it "knows if it's removed" do
    expect(comment).not_to be_removed

    comment.removed_at = Time.current
    expect(comment).to be_removed
  end

  it "knows if it's blocked" do
    expect(comment).not_to be_blocked

    comment.blocked_at = Time.current
    expect(comment).to be_blocked
  end
end
