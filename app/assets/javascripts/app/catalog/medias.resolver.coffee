MediasResolver = (PageLoading, Media) ->
  PageLoading.resolve Media.search()

MediasResolver.$inject = ['PageLoading', 'Media']

angular
  .module('app.catalog')
  .constant 'MediasResolver', MediasResolver
