class RegistrationsMailer < Devise::Mailer
  include Roadie::Rails::Mailer

  def successful_registration(user_or_id)
    fail "Disabled, please see #819"
    @user = User.find(user_or_id)
    roadie_mail(to: @user.email, subject: 'Cadastro realizado com sucesso!')
  end
end
