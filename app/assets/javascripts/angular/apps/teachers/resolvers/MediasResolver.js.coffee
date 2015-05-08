DunnoApp = angular.module('DunnoApp')

resolver = (PageLoading, Media) ->
  PageLoading.resolve Media.search()

resolver.$inject = ['PageLoading', 'Media']
DunnoApp.constant 'MediasResolver', resolver
