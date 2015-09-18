angular
  .module 'app.lessonPlan', [
    'ui.keypress',
    'ui.sortable',
    'pascalprecht.translate'
  ]

lessonPlan = angular.module('app.lessonPlan')

lessonPlan.config ['$translateProvider', ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'textTopicForm.description.required': 'Você precisa preencher o tópico.'

    'fileMediaForm.file.required': 'Você precisa enviar um arquivo.'

    'fileTopicForm.description.required': 'Você precisa preencher o nome do arquivo.'

    'urlMediaForm.url.required': 'Você precisa preencher o link.'
    'urlMediaForm.url.url': 'O formato do link é inválido.'

    'urlTopicForm.description.required': 'Você precisa preencher o nome do link'

    'catalogTopicForm.media.required': 'Você precisa escolher um item do catálogo.'
]
