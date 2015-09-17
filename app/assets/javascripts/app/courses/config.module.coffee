angular
  .module 'app.courses', [
    'pascalprecht.translate'
  ]

courses = angular.module('app.courses')

courses.config ['$translateProvider', ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'courseForm.name.required': 'Você precisa informar o nome da disciplina.'

    'courseForm.start_date.required': 'Você precisa informar a data inicial da disciplina.'
    'courseForm.start_date.parse': 'O formato desta data está inválido. Exemplo de uma data correta: 30/01/2015'

    'courseForm.end_date.parse': 'O formato desta data está inválido. Exemplo de uma data correta: 30/01/2015'
]
