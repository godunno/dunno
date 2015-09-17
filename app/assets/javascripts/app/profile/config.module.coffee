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
]
