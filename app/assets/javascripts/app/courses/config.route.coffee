setCoursesRoutes = (
  $stateProvider,
  CoursesResolver,
  CourseResolver,
  EventsPaginationResolver) ->
  $stateProvider
    .state 'courses',
      url: '/courses'
      controller: 'CoursesIndexCtrl as vm'
      templateUrl: 'courses/courses'
      resolve:
        courses: CoursesResolver
        $title: ['$translate', ($translate) -> $translate('courses.title.courses')]

    .state 'courses.inactive',
      url: '/inactive'
      templateUrl: 'courses/courses-inactive'

    .state 'courses.show',
      url: '/:courseId'
      abstract: true
      controller: 'CourseCtrl'
      templateUrl: 'courses/course-detail'
      resolve:
        course: CourseResolver
        $title: ['$translate', 'course', ($translate, course) ->
          $translate('courses.title.course-detail', course: course)]

    .state 'courses.show.events',
      url: '/events?month&startAt&commentId&trackEventCanceled'
      controller: 'CourseEventsCtrl as vm'
      templateUrl: 'courses/events/events'
      resolve: { pagination: EventsPaginationResolver }
      params:
        startAt: { value: null, squash: true }
        commentId: { value: null, squash: true }

    .state 'courses.show.schedule',
      url: '/schedule'
      controller: 'ScheduleCtrl'
      templateUrl: 'courses/schedule/schedule'

    .state 'courses.show.members',
      url: '/members'
      controller: 'CourseMembersCtrl as vm'
      templateUrl: 'courses/members/members'

setCoursesRoutes.$inject = [
  '$stateProvider',
  'CoursesResolver',
  'CourseResolver',
  'EventsPaginationResolver']

angular
  .module('app.courses')
  .config(setCoursesRoutes)
