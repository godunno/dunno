# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'sign_in_form.email.required': 'Você precisa informar seu email.'
    'sign_in_form.email.email': 'Isto não parece ser um e-mail.'
    'sign_in_form.password.required': 'Você precisa informar sua senha.'

    'sign_up_form.name.required': 'Você precisa de um nome no Dunno.'
    'sign_up_form.email.required': 'Você precisa informar seu email.'
    'sign_up_form.email.email': 'Isto não parece ser um e-mail.'
    'sign_up_form.password.required': 'Você precisa escolher uma senha.'
    'sign_up_form.password.minlength': 'Sua senha deve conter no mínimo 8 caracteres'
    'sign_up_form.phone_number.required': 'Você precisa preencher seu telefone.'
    'sign_up_form.phone_number.brPhoneNumber': 'O formato informado é inválido.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.users')
  .config(I18nConfig)
