# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'courseForm.name.required': 'Você precisa informar o nome da disciplina.'
    'courseForm.start_date.required': 'Você precisa informar a data inicial da disciplina.'
    'courseForm.start_date.parse': 'O formato desta data está inválido. Exemplo de uma data correta: 30/01/2015'
    'courseForm.end_date.parse': 'O formato desta data está inválido. Exemplo de uma data correta: 30/01/2015'

    'vm.notificationForm.message.required': 'Você precisa preencher uma mensagem.'
    'vm.notificationForm.message.repeated': 'Essa notificação é igual à última enviada.'
    'vm.notificationForm.abbreviation.required': 'Você precisa preencher uma abreviação para sua disciplina.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.courses')
  .config(I18nConfig)
