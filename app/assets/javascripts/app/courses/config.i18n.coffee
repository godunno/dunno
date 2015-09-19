# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    courses:
      title:
        courses: 'Minhas Disciplinas'
        'course-detail': '{{course.name}} › {{course.class_name}}'
    'courseForm.name.required': 'Nós precisamos de um nome para a sua disciplina.'
    'courseForm.startDate.required': 'A disciplina deve ter uma data de começo.'
    'courseForm.startDate.parse': 'Preencha a data usando o formato  DD/MM/AAAA.'
    'courseForm.endDate.parse': 'Preencha a data usando o formato  DD/MM/AAAA.'

    'vm.notificationForm.message.required': 'Insira uma mensagem para seus estudantes.'
    'vm.notificationForm.message.repeated': 'Você não pode enviar duas mensagens iguais em sequência.'
    'vm.notificationForm.abbreviation.required': 'Identifique sua disciplina usando uma abreviação.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.courses')
  .config(I18nConfig)
