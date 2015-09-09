EventsPaginationResolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.paginate(course_id: $stateParams.courseId, until: $stateParams.until)

EventsPaginationResolver.$inject = ['$stateParams', 'PageLoading', 'Event']
angular
  .module('app.courses')
  .constant('EventsPaginationResolver', EventsPaginationResolver)
