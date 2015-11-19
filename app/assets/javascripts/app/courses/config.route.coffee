setCoursesRoutes = (
  $stateProvider,
  CoursesResolver,
  CourseResolver,
  EventsPaginationResolver) ->
  $stateProvider
    .state 'app.courses',
      url: '/courses'
      controller: 'CoursesIndexCtrl as vm'
      templateUrl: 'courses/courses'
      resolve:
        courses: CoursesResolver
        $title: ['$translate', ($translate) -> $translate('courses.title.courses')]

    .state 'app.courses.inactive',
      url: '/inactive'
      templateUrl: 'courses/courses-inactive'

    .state 'app.courses.show',
      url: '/:courseId'
      abstract: true
      controller: 'CourseCtrl'
      templateUrl: 'courses/course-detail'
      resolve:
        course: CourseResolver
        $title: ['$translate', 'course', ($translate, course) ->
          $translate('courses.title.course-detail', course: course)]

    .state 'app.courses.show.events',
      url: '/events?month&startAt&commentId&trackEventCanceled'
      controller: 'CourseEventsCtrl as vm'
      templateUrl: 'courses/events/events'
      resolve: { pagination: EventsPaginationResolver }
      params:
        startAt: { value: null, squash: true }
        commentId: { value: null, squash: true }

    .state 'app.courses.show.schedule',
      url: '/schedule'
      controller: 'ScheduleCtrl'
      templateUrl: 'courses/schedule/schedule'

    .state 'app.courses.show.members',
      url: '/members'
      controller: 'CourseMembersCtrl as vm'
      templateUrl: 'courses/members/members'

    .state 'app.courses.show.catalog',
      url: '/catalog'
      controller: 'CourseCatalogCtrl as vm'
      templateUrl: 'courses/catalog/course-catalog'

    .state 'app.courses.show.analytics',
      url: '/analytics'
      controller: 'CourseAnalyticsCtrl as vm'
      templateUrl: 'courses/analytics/course-analytics'

setCoursesRoutes.$inject = [
  '$stateProvider',
  'CoursesResolver',
  'CourseResolver',
  'EventsPaginationResolver']

angular
  .module('app.courses')
  .config(setCoursesRoutes)
