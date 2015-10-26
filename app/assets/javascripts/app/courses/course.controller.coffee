CourseCtrl = ($scope, ModalFactory, course) ->
  $scope.course = course

  $scope.openEditCourseForm = ->
    new ModalFactory
      templateUrl: 'courses/course-edit'
      controller: 'EditCourseCtrl'
      class: 'medium course__edit'
      controllerAs: 'vm'
      bindToController: true
      resolve: { course: -> angular.copy($scope.course) }
      scope: $scope
    .activate()

  $scope.openNotification = ->
    new ModalFactory
      templateUrl: 'courses/notify/notify-members'
      controller: 'NotificationCtrl'
      class: 'medium send__notification'
      controllerAs: 'vm'
      bindToController: true
      resolve: { course: -> angular.copy($scope.course) }
    .activate()


CourseCtrl.$inject = [
  '$scope',
  'ModalFactory',
  'course'
]

angular
  .module('app.courses')
  .controller('CourseCtrl', CourseCtrl)
