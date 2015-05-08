DunnoApp = angular.module('DunnoApp')

resolver = (PageLoading, Event) ->
  PageLoading.resolve Event.query()

resolver.$inject = ['PageLoading', 'Event']
DunnoApp.constant 'EventsResolver', resolver
