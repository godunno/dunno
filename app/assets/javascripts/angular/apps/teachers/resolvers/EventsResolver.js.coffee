DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.query(course_id: $stateParams.courseId, until: $stateParams.until)

resolver.$inject = ['$stateParams', 'PageLoading', 'Event']
DunnoApp.constant 'EventsResolver', resolver
