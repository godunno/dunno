EventResolver = ($stateParams, PageLoading, Event) ->
  PageLoading.resolve Event.get({ start_at: $stateParams.startAt }, { course_id: $stateParams.courseId })

EventResolver.$inject = ['$stateParams', 'PageLoading', 'Event']

angular
  .module('app.lessonPlan')
  .constant('EventResolver', EventResolver)
