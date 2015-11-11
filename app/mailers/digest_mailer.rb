class DigestMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout 'email'
  helper 'events'

  def digest(profile)
    @notifications_digest = BuildDigest.new(profile).notifications
    @profile = profile
    mail to: profile.email, subject: "\xE2\x98\x95 Ontem no Dunno"
  end
end
