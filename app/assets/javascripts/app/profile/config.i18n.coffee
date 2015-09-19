# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'profile_form.name.required': 'Você precisa de um nome no Dunno.'
    'profile_form.phone_number.required': 'Você precisa preencher seu telefone.'
    'profile_form.phone_number.brPhoneNumber': 'Você precisa inserir um numero de telefone válido.'

    'password_form.current_password.required': 'Você precisa de uma senha no Dunno.'
    'password_form.password.required': 'Digite sua nova senha.'
    'password_form.password.minlength': 'A sua senha precisa ter ao menos 8 caracteres.'
    'password_form.password_confirmation.required': 'Digite novamente a sua nova senha.'
    'password_form.password_confirmation.match': 'As duas senhas estão diferentes.'
    'password_form.password_confirmation.parse': ''

    'new_password_recovery_form.email.required': 'Digite seu e-mail para recuperar sua senha.'
    'new_password_recovery_form.email.email': 'Isto não parece ser um e-mail.'

    'password_recovery_form.password.required': 'Informe uma nova senha.'
    'password_recovery_form.password.minlength': 'A nova senha precisa ter ao menos 8 caracteres.'
    'password_recovery_form.password_confirmation.required': 'Você precisa confirmar a senha.'
    'password_recovery_form.password_confirmation.match': 'As duas senhas estão diferentes.'
    'password_recovery_form.password_confirmation.parse': ''

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.profile')
  .config(I18nConfig)
