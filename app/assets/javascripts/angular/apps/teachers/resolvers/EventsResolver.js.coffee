DunnoApp = angular.module('DunnoApp')

resolver = (ModelResolver, Event) ->
  ModelResolver.resolve Event.query()

resolver.$inject = ['ModelResolver', 'Event']
DunnoApp.constant 'EventsResolver', events: resolver
