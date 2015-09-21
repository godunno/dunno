setupJoinRoutes = (
  $stateProvider,
  CourseRegistrationResolver) ->

  $stateProvider
    .state 'courses.search',
      url: '/search'
      controller: 'CourseSearchCtrl'
      templateUrl: 'join/course-join'

    .state 'courses.confirm_registration',
      url: '/:id/confirm_registration'
      controller: 'CourseConfirmRegistrationCtrl'
      templateUrl: 'join/course-confirm'
      resolve: { course: CourseRegistrationResolver }

setupJoinRoutes.$inject = [
  '$stateProvider',
  'CourseRegistrationResolver']

angular
  .module('app.join')
  .config(setupJoinRoutes)

