EventsPaginationResolver = ($stateParams, PageLoading, Event) ->
  params =
    course_id: $stateParams.courseId
    month: $stateParams.month || $stateParams.startAt
  PageLoading.resolve Event.paginate(params)

EventsPaginationResolver.$inject = ['$stateParams', 'PageLoading', 'Event']
angular
  .module('app.courses')
  .constant('EventsPaginationResolver', EventsPaginationResolver)
