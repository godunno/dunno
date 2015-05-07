DunnoApp = angular.module('DunnoApp')

resolver = ($route, ModelResolver, Event) ->
  ModelResolver.resolve Event.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'ModelResolver', 'Event']
DunnoApp.constant 'EventResolver', event: resolver
