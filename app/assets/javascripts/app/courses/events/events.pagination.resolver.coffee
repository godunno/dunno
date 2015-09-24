EventsPaginationResolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.paginate(course_id: $stateParams.courseId, month: $stateParams.month)

EventsPaginationResolver.$inject = ['$stateParams', 'PageLoading', 'Event']
angular
  .module('app.courses')
  .constant('EventsPaginationResolver', EventsPaginationResolver)
