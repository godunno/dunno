DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.query(course_id: $stateParams.courseId)

resolver.$inject = ['$stateParams', 'PageLoading', 'Event']
DunnoApp.constant 'EventsResolver', resolver
