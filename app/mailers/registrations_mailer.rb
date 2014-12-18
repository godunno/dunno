class RegistrationsMailer < Devise::Mailer
  include Roadie::Rails::Automatic

  def invitation(user, token)
    @user = user
    @token = token
    mail(to: user.email, subject: "Bem-vindo(a) ao Dunno!")
  end
end
