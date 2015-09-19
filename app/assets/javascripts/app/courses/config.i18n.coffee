# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'courseForm.name.required': 'Nós precisamos de um nome para a sua disciplina.'
    'courseForm.start_date.required': 'A disciplina deve ter uma data de começo.'
    'courseForm.start_date.parse': 'Preencha a data usando o formato  DD/MM/AAAA.'
    'courseForm.end_date.parse': 'Preencha a data usando o formato  DD/MM/AAAA.'

    'vm.notificationForm.message.required': 'Insira uma mensagem para seus estudantes.'
    'vm.notificationForm.message.repeated': 'Você não pode enviar duas mensagens iguais em sequência.'
    'vm.notificationForm.abbreviation.required': 'Identifique sua disciplina usando uma abreviação.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.courses')
  .config(I18nConfig)
