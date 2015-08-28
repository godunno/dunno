DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Event) ->
  # TODO: Extract the responsibility to include course_id in the params to the Event model
  PageLoading.resolve Event.get({ start_at: $stateParams.startAt }, { course_id: $stateParams.courseId })

resolver.$inject = ['$stateParams', 'PageLoading', 'Event']
DunnoApp.constant 'EventResolver', resolver
