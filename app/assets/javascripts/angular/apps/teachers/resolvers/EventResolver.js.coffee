DunnoApp = angular.module('DunnoApp')

resolver = ($route, PageLoading, Event) ->
  PageLoading.resolve Event.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'PageLoading', 'Event']
DunnoApp.constant 'EventResolver', resolver
