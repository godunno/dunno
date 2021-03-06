# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'signInForm.email.required': 'Você precisa informar seu email.'
    'signInForm.email.email': 'Isto não parece ser um email.'
    'signInForm.password.required': 'Você precisa informar sua senha.'

    'signUpForm.name.required': 'Você precisa informar seu nome.'
    'signUpForm.email.required': 'Você precisa informar seu email.'
    'signUpForm.email.email': 'Isto não parece ser um email.'
    'signUpForm.email.taken': 'Este email já está sendo utilizado.'
    'signUpForm.password.required': 'Você precisa escolher uma senha.'
    'signUpForm.password.minlength': 'Sua senha deve conter no mínimo 8 caracteres'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.users')
  .config(I18nConfig)
