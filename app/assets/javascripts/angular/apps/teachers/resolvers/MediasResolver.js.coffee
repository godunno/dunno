DunnoApp = angular.module('DunnoApp')

resolver = (ModelResolver, Media) ->
  ModelResolver.resolve Media.search()

resolver.$inject = ['ModelResolver', 'Media']
DunnoApp.constant 'MediasResolver', searchResult: resolver
