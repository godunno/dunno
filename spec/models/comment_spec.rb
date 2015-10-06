require 'spec_helper'

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :profile }
    it { is_expected.to belong_to :event }
    it { is_expected.to have_many :attachments }
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
end
