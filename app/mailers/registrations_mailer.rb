class RegistrationsMailer < Devise::Mailer
  include Roadie::Rails::Automatic

  def invitation(user_or_id)
    @user = User.find(user_or_id)
    @token = @user.invitation_token
    mail(to: @user.email, subject: 'Bem-vindo(a) ao Dunno!')
  end

  def successful_registration(user_or_id)
    fail "Disabled, please see #819"
    @user = User.find(user_or_id)
    mail(to: @user.email, subject: 'Cadastro realizado com sucesso!')
  end
end
