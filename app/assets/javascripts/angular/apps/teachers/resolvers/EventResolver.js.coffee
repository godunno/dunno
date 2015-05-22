DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = ($route, PageLoading, Event) ->
  PageLoading.resolve Event.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'PageLoading', 'Event']
DunnoApp.constant 'EventResolver', resolver
DunnoAppStudent.constant 'EventResolver', resolver
