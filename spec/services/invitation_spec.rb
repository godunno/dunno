require 'spec_helper'

describe Invitation do
  let(:invitation_token) { "6jVQ9psuHr64ycAdUL6C" }
  let(:user) { create(:user) }
  let(:invitation) { Invitation.new(user) }
  before do
    allow(Devise).to receive(:friendly_token).and_return(invitation_token)
  end

  context "before invite" do
    it "should generate a invitation_token" do
      expect { invitation.invite! }.to change { user.reload.invitation_token }.from(nil).to(invitation_token)
    end

    it "sends an e-mail on invite" do
      expect { invitation.invite! }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "should timestamp the invitation" do
      now = Time.zone.now.change(usec: 0)
      Timecop.freeze(now)
      expect { invitation.invite! }.to change { user.reload.invitation_sent_at }.from(nil).to(now)
      Timecop.return
    end

    it { expect(invitation).to be_expired }
  end

  context "after invite" do
    before do
      invitation.invite!
    end

    it { expect(invitation).not_to be_expired }

    it "should expire the invitation" do
      Timecop.freeze(Invitation::EXPIRE_AFTER + 1.day)
      expect(invitation).to be_expired
      Timecop.return
    end

    it { expect { invitation.invite! }.to raise_error(Invitation::AlreadyInvitedError) }

    it "should resend invitation" do
      new_invitation_token = "yv1694Fbytd-Ko3art-g"
      allow(Devise).to receive(:friendly_token).and_return(new_invitation_token)
      expect { invitation.reinvite! }.not_to raise_error
      expect(user.reload.invitation_token).to eq(new_invitation_token)
    end
  end
end
