# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    profile:
      title:
        edit: 'Meu Perfil'

    'profileForm.name.required': 'Você precisa de um nome no Dunno.'

    'passwordForm.currentPassword.required': 'Você precisa de uma senha no Dunno.'
    'passwordForm.password.required': 'Digite sua nova senha.'
    'passwordForm.password.minlength': 'A sua senha precisa ter ao menos 8 caracteres.'
    'passwordForm.passwordConfirmation.required': 'Digite novamente a sua nova senha.'
    'passwordForm.passwordConfirmation.match': 'As duas senhas estão diferentes.'
    'passwordForm.passwordConfirmation.parse': ''
    'passwordForm.currentPassword.invalid': 'A senha informada está incorreta.'

    'newPasswordRecoveryForm.email.required': 'Digite seu e-mail para recuperar sua senha.'
    'newPasswordRecoveryForm.email.email': 'Isto não parece ser um e-mail.'

    'passwordRecoveryForm.password.required': 'Informe uma nova senha.'
    'passwordRecoveryForm.password.minlength': 'A nova senha precisa ter ao menos 8 caracteres.'
    'passwordRecoveryForm.passwordConfirmation.required': 'Você precisa confirmar a senha.'
    'passwordRecoveryForm.passwordConfirmation.match': 'As duas senhas estão diferentes.'
    'passwordRecoveryForm.passwordConfirmation.parse': ''

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.profile')
  .config(I18nConfig)
