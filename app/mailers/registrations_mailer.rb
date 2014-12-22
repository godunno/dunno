class RegistrationsMailer < Devise::Mailer
  include Roadie::Rails::Automatic

  def invitation(user)
    @user = user
    @token = user.invitation_token
    mail(to: user.email, subject: "Bem-vindo(a) ao Dunno!")
  end
end
