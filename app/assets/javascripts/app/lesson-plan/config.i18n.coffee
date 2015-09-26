# coffeelint: disable=max_line_length

I18nConfig = ($translateProvider) ->
  $translateProvider.translations 'pt-BR',
    'textTopicForm.description.required': 'Insira o conteúdo do seu tópico.'

    'fileMediaForm.file.required': 'Você precisa selecionar um arquivo.'
    'fileTopicForm.description.required': 'Você precisa dar um nome a seu arquivo.'

    'urlMediaForm.url.required': 'Cole o link que você deseja compartilhar.'
    'urlMediaForm.url.url': 'O link tem que ser uma URL válida, começando com http://'
    'urlTopicForm.description.required': 'Dê um título ao seu link.'

    'catalogTopicForm.media.required': 'Escolha um item do catálogo para inserir.'

I18nConfig.$inject = ['$translateProvider']

angular
  .module('app.lessonPlan')
  .config(I18nConfig)
