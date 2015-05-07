DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = ($route, ModelResolver, Event) ->
  ModelResolver.resolve Event.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'ModelResolver', 'Event']
DunnoAppStudent.constant 'EventResolver', event: resolver
