EventsResolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.query(course_id: $stateParams.courseId, until: $stateParams.until)

EventsResolver.$inject = ['$stateParams', 'PageLoading', 'Event']

angular
  .module('app.agenda')
  .constant('EventsResolver', EventsResolver)
