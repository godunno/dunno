DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.get(uuid: $stateParams.eventId)

resolver.$inject = ['$stateParams', 'PageLoading', 'Event']
DunnoApp.constant 'EventResolver', resolver
