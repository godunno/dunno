DunnoApp = angular.module('DunnoApp')

# TODO: Separar controller de show e edit
CourseCtrl = ($scope, $location, $routeParams, Course, Utils, DateUtils, course)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.course = new Course()

  $scope.course.weekly_schedules = [{}]

  $scope.eventClass = (event)->
    klass = DateUtils.locationInTime(event.start_at)
    klass += " has-tooltip" if $scope.hideEvent(event)
    klass

  $scope.statusFor = (event)->
    return "empty" if $scope.course.user_role == 'student' && event.formatted_status == "draft"
    event.formatted_status

  $scope.fetch = (month)->
    $scope.$emit('wholePageLoading', Course.get({ uuid: $routeParams.id }, { month: month || $routeParams.month }).then (course)->
      $scope.course = formatToView(course)
      $location.search('month', month)
    )

  $scope.course = course

  $scope.save = (course)->
    $scope.isSending = true
    course.save().then(->
      $location.path "/courses/#{course.uuid}/"
    ).finally(-> $scope.isSending = false)

  $scope.delete = (course)->
    if confirm("Deseja mesmo remover a disciplina #{course.name}? Esta operação não poderá ser desfeita.")
      course.delete().then ->
        $location.path '#/courses'

  formatToView = (course)->
      course.start_date = $scope.formattedDate(course.start_date, 'dd/MM/yyyy')
      course.end_date   = $scope.formattedDate(course.end_date,   'dd/MM/yyyy')
      course

  $scope.eventPath = (event)->
    return if $scope.hideEvent(event)
    "#/events/#{event.uuid}"

  $scope.hideEvent = (event)->
    return false if $scope.course.user_role == 'teacher'
    (['empty', 'canceled'].indexOf $scope.statusFor(event)) != -1

  $scope.tooltipMessage = (event)->
    return undefined unless $scope.hideEvent(event)
    if $scope.statusFor(event) == 'canceled'
      'Esta aula foi cancelada'
    else
      'Esta aula ainda está vazia'

CourseCtrl.$inject = [
  '$scope', '$location', '$routeParams', 'Course', 'Utils', 'DateUtils', 'course'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

