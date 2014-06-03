DunnoApp = angular.module 'DunnoApp', ['ngRoute', 'ngResource']

Router = ($routeProvider)->
  $routeProvider.
    when('/courses', controller: 'CoursesIndexCtrl', templateUrl: '/assets/courses/index.html').
    when('/courses/new', controller: 'CourseCtrl', templateUrl: '/assets/courses/form.html').
    when('/courses/:id', controller: 'CourseCtrl', templateUrl: '/assets/courses/show.html').
    when('/courses/:id/edit', controller: 'CourseCtrl', templateUrl: '/assets/courses/form.html').
    when('/events/new', controller: 'EventCtrl', templateUrl: '/assets/events/form.html').
    when('/events/:id/edit', controller: 'EventCtrl', templateUrl: '/assets/events/form.html').
    otherwise(redirectTo: '/courses')
Router.$inject = ['$routeProvider', '$locationProvider']
DunnoApp.config Router
