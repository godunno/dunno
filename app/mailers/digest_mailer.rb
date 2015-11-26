class DigestMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  layout 'email'
  helper 'events'
  helper 'angular'

  def digest(profile_id, notifications_ids)
    profile = Profile.find(profile_id)
    notifications = SystemNotification.find(notifications_ids)
    @notifications_digest = BuildDigest.new(profile, notifications).notifications
    @profile = profile
    roadie_mail to: profile.email, subject: "\xE2\x98\x95 Café da manhã com Dunno"
  end
end
