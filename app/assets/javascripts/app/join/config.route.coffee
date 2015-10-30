setupJoinRoutes = (
  $stateProvider,
  CourseRegistrationResolver) ->

  $stateProvider
    .state 'app.courses.search',
      url: '/search'
      controller: 'CourseSearchCtrl'
      templateUrl: 'join/course-join'

    .state 'app.courses.confirm_registration',
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

