angular
  .module 'app.users', [
    'pascalprecht.translate']

users = angular.module('app.users')

users.config ['$translateProvider', ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'sign_in_form.email.required'   : 'Você precisa informar seu email.'
    'sign_in_form.email.email'      : 'O email informado é inválido.'
    'sign_in_form.password.required': 'Você precisa informar sua senha.'
]
