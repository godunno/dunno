DunnoApp = angular.module('DunnoApp')

# TODO: Separar controller de show e edit
CourseCtrl = ($scope, $location, $stateParams, $state, Course, Utils, DateUtils, course)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.course = new Course()

  $scope.course.weekly_schedules = [{}]

  $scope.eventClass = (event) ->
    klass = DateUtils.locationInTime(event.start_at)
    klass += " has-tooltip" unless $scope.canAccessEvent(event)
    klass

  $scope.fetch = (month) ->
    $scope.$emit('wholePageLoading', Course.get({ uuid: $stateParams.id }, { month: month || $stateParams.month }).then (course)->
      $scope.course = formatToView(course)
    )

  $scope.course = course

  $scope.save = (course) ->
    $scope.isSending = true
    course.save().then(->
      $location.path "/courses/#{course.uuid}/"
    ).finally(-> $scope.isSending = false)

  $scope.delete = (course) ->
    if confirm("Deseja mesmo remover a disciplina #{course.name}? Esta operação não poderá ser desfeita.")
      course.delete().then ->
        $location.path '#/courses'

  formatToView = (course) ->
      course.start_date = $scope.formattedDate(course.start_date, 'dd/MM/yyyy')
      course.end_date   = $scope.formattedDate(course.end_date,   'dd/MM/yyyy')
      course

  $scope.goToEvent = (event) ->
    return unless $scope.canAccessEvent(event)
    $state.go('^.event', { eventId: event.uuid })

  $scope.canAccessEvent = (event) ->
    event.status == 'published' || $scope.course.user_role == 'teacher'

  $scope.tooltipMessage = (event) ->
    return undefined if $scope.canAccessEvent(event)
    if event.formatted_status == 'canceled'
      'Esta aula foi cancelada'
    else
      'Esta aula ainda está vazia'

  $scope.toggleMobileInfoVisibility = (event) ->
    $('.mobile__info__slide__toggle').slideToggle()
    $('.slide__mobile__info .icon').toggleClass('icon-chevron-down').toggleClass('icon-chevron-up')
    return false

CourseCtrl.$inject = [
  '$scope', '$location', '$stateParams', '$state', 'Course', 'Utils', 'DateUtils', 'course'
]
DunnoApp.controller 'CourseCtrl', CourseCtrl

