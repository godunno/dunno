class DigestMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout 'email'
  helper 'events'
  helper 'angular'

  def digest(profile_id)
    profile = Profile.find(profile_id)
    @notifications_digest = BuildDigest.new(profile).notifications
    @profile = profile
    mail to: profile.email, subject: "\xE2\x98\x95 Ontem no Dunno"
  end
end
