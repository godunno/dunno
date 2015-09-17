angular
  .module 'app.profile', [
    'validation.match',
    'pascalprecht.translate'
  ]

profile = angular.module('app.profile')

profile.config ['$translateProvider', ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'profile_form.name.required': 'Você precisa informar seu nome.'
    'profile_form.phone_number.required': 'Você precisa informar seu telefone.'
    'profile_form.phone_number.brPhoneNumber': 'O formato inserido não é válido.'

    'password_form.current_password.required': 'Você precisa informar sua senha.'
    'password_form.password.required': 'Você precisa informar a nova senha.'
    'password_form.password.minlength': 'A nova senha precisa ter ao menos 8 caracteres.'
    'password_form.password_confirmation.required': 'Você precisa confirmar a senha.'
    'password_form.password_confirmation.match': 'A confirmação não é igual à senha digitada.'
    'password_form.password_confirmation.parse': ''

    'new_password_recovery_form.email.required': 'Você precisa confirmar seu email.'
    'new_password_recovery_form.email.email': 'O email informado é inválido.'
]
