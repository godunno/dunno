# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    courses:
      title:
        courses: 'Disciplinas'
        'course-detail': '{{course.name}} › {{course.class_name}}'
        'course-clone-confirm': 'Clonar {{course.name}}'
    'vm.courseForm':
      name:
        required: 'Nós precisamos de um nome para a sua disciplina.'
      startDate:
        required: 'A disciplina deve ter uma data de começo.'
        parse: 'Preencha a data usando o formato  DD/MM/AAAA.'
        after_end_date: 'A data de início deve vir antes da data de término.'
      endDate:
        parse: 'Preencha a data usando o formato  DD/MM/AAAA.'
    'vm.commentForm':
      commentBody:
        required: 'Escreva alguma coisa para a sua turma.'

    vm:
      weeklyScheduleForm:
        startTime:
          time: 'Você deve preencher o horário de início da aula.'
          overlapping: 'Já existe um horário nesse período.'
          after_end_time: 'O início deve ser antes do término.'

        endTime:
          time: 'Você deve preencher o horário de término da aula.'

    'vm.notificationForm.message.required': 'Insira uma mensagem para seus estudantes.'
    'vm.notificationForm.message.repeated': 'Você não pode enviar duas mensagens iguais em sequência.'
    'vm.notificationForm.abbreviation.required': 'Identifique sua disciplina usando uma abreviação.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.courses')
  .config(I18nConfig)
