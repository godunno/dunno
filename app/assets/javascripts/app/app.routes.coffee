Router = ($stateProvider,
          $urlRouterProvider,
          CoursesResolver,
          CourseResolver,
          CourseRegistrationResolver,
          EventsPaginationResolver,
          EventResolver,
          MediasResolver) ->
  $urlRouterProvider.otherwise('/courses')
  $stateProvider
    .state('courses',
      url: '/courses'
      controller: 'CoursesIndexCtrl as vm'
      templateUrl: 'courses/courses'
      resolve: { courses: CoursesResolver }
    )
    .state('courses.inactive',
      url: '/inactive'
      templateUrl: 'courses/courses-inactive'
    )
    .state('courses.search',
      url: '/search'
      controller: 'CourseSearchCtrl'
      templateUrl: 'join/course-join'
    )
    .state('courses.confirm_registration',
      url: '/:id/confirm_registration'
      controller: 'CourseConfirmRegistrationCtrl'
      templateUrl: 'join/course-confirm'
      resolve: { course: CourseRegistrationResolver }
    )
    .state('courses.show',
      url: '/:courseId'
      abstract: true
      controller: 'CourseCtrl'
      templateUrl: 'courses/course-detail'
      resolve: { course: CourseResolver }
    )
    .state('courses.show.calendar',
      url: '/calendar?month'
      controller: 'CalendarCtrl'
      templateUrl: 'courses/calendar/calendar'
      resolve: { course: CourseResolver }
    )
    .state('courses.show.events',
      url: '/events?until'
      controller: 'CourseEventsCtrl'
      templateUrl: 'courses/events/events'
      resolve: { pagination: EventsPaginationResolver }
    )
    .state('courses.show.calendar.schedule',
      url: '/schedule'
      controller: 'ScheduleCtrl'
      templateUrl: 'courses/schedule/schedule'
    )
    .state('courses.show.members',
      url: '/members'
      controller: 'CourseMembersCtrl as vm'
      templateUrl: 'courses/members/members'
      resolve: { course: CourseResolver }
    )
    .state('courses.show.event',
      url: '/events/:startAt'
      views:
          '@':
            templateUrl: 'lesson-plan/lesson-plan-edit'
            controller: 'EventCtrl'
      resolve: { event: EventResolver }
    )
    .state('events.show',
      url: '/:startAt?courseId'
      controller: 'EventCtrl'
      templateUrl: 'lesson-plan/lesson-plan-edit'
      resolve: { event: EventResolver }
    )
    .state('medias',
      url: '/catalog'
      controller: 'MediasIndexCtrl'
      templateUrl: 'catalog/catalog'
      resolve: { searchResult: MediasResolver }
    )
    .state('profile',
      url: '/profile/edit'
      controller: 'ProfileCtrl'
      templateUrl: 'profile/profile'
    )
    .state('profile.change_password',
      url: '/profile/password/edit'
      controller: 'PasswordCtrl'
      templateUrl: 'profile/password'
    )

Router.$inject = [
  '$stateProvider',
  '$urlRouterProvider',
  'CoursesResolver',
  'CourseResolver',
  'CourseRegistrationResolver',
  'EventsPaginationResolver',
  'EventResolver',
  'MediasResolver']

angular
  .module('app')
  .config(Router)
