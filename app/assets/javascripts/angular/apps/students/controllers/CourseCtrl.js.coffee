DunnoApp = angular.module('DunnoAppStudent')

# TODO: Separar controller de show e add
CourseCtrl = ($scope, $location, $routeParams, Course, DateUtils, SessionManager)->
  angular.extend($scope, DateUtils)

  $scope.hideEvent = (event)-> (['empty', 'canceled'].indexOf $scope.statusFor(event)) != -1
  $scope.tooltipMessage = (event)->
    return undefined unless $scope.hideEvent(event)
    if $scope.statusFor(event) == 'canceled'
      'Esta aula foi cancelada'
    else
      'Esta aula ainda está vazia'

  $scope.statusFor = (event)->
    return "empty" if event.formatted_status == "draft"
    event.formatted_status

  $scope.eventClass = (event)->
    klass = DateUtils.locationInTime(event.start_at)
    klass += " has-tooltip" if $scope.hideEvent(event)
    klass

  $scope.course = new Course()

  $scope.fetch = (month)->
    $scope.$emit('wholePageLoading', Course.get({ access_code: $routeParams.id }, { month: month || $routeParams.month }).then (course)->
      $scope.course = course
      $location.search('month', month)
    )

  if $routeParams.id
    $scope.fetch()

  $scope.search = (access_code)->
    if (SessionManager.currentUser().courses.indexOf access_code) != -1
      $location.path "/courses/#{access_code}"
    else
      $scope.error = false
      $scope.$emit('wholePageLoading', Course.get(access_code: access_code).then (course)->
        $location.path "/courses/#{access_code}/confirm_registration"
      , -> $scope.error = true
      )

  $scope.register = (course)->
    course.register().then ->
      SessionManager.fetchUser().then ->
        $location.path "/courses"

  $scope.eventPath = (event)->
    return if $scope.hideEvent(event)
    "#/events/#{event.uuid}"
CourseCtrl.$inject = [
  '$scope', '$location', '$routeParams', 'Course', 'DateUtils', 'SessionManager'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

