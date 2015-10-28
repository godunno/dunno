setupLessonPlanRoutes = (
  $stateProvider,
  EventResolver) ->
  $stateProvider
    .state 'app.courses.show.event',
      url: '/events/:startAt'
      views:
        '@':
          templateUrl: 'lesson-plan/lesson-plan-edit'
          controller: 'EventCtrl'
      resolve: { event: EventResolver }

    .state 'app.events.show',
      url: '/:startAt?courseId'
      controller: 'EventCtrl'
      templateUrl: 'lesson-plan/lesson-plan-edit'
      resolve: { event: EventResolver }

setupLessonPlanRoutes.$inject = [
  '$stateProvider',
  'EventResolver']

angular
  .module('app.lessonPlan')
  .config(setupLessonPlanRoutes)
