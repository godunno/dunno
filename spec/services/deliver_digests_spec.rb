require 'spec_helper'

describe DeliverDigests do
  let!(:profile_with_recent_notifications) { create(:profile, last_digest_sent_at: 1.day.ago) }
  let!(:profile_without_recent_notifications) { create(:profile, last_digest_sent_at: 1.day.ago) }

  let!(:recent_notification) do
    create(:system_notification, :new_comment, profile: profile_with_recent_notifications)
  end

  let!(:old_notification) do
    create :system_notification, :new_comment,
           profile: profile_without_recent_notifications,
           created_at: 2.days.ago
  end

  let(:delayed_mailer) { double("Delayed Mailer", digest: nil) }

  def do_service
    DeliverDigests.new.deliver
  end

  before do
    allow(DigestMailer).to receive(:delay).and_return(delayed_mailer)
    Timecop.freeze
  end

  after do
    Timecop.return
    ActionMailer::Base.deliveries.clear
  end

  it do
    expect { do_service }
      .to change { profile_with_recent_notifications.reload.last_digest_sent_at.change(usec: 0) }
      .to(Time.current.change(usec: 0))
  end
  it do
    expect { do_service }
      .not_to change { profile_without_recent_notifications.reload.last_digest_sent_at }
  end

  it "only delivers the digest for the profiles with recent notifications" do
    expect(delayed_mailer).to receive(:digest).with(profile_with_recent_notifications)
    expect(delayed_mailer).not_to receive(:digest).with(profile_without_recent_notifications)
    do_service
  end
end
