eventStatusCtrl = ($scope) ->
  event  = $scope.event
  role = $scope.role

  @translatedStatus = =>
    if @isCanceled()
      'Cancelada'
    else if @isPublished()
      'Publicada'
    else if @isDraft()
      'Rascunho'

  @isCanceled = ->
    event.formatted_status == 'canceled'

  @isPublished = ->
    event.formatted_status == 'published' ||
    event.formatted_status == 'happened'

  @isDraft = ->
    event.formatted_status == 'draft' ||
    event.formatted_status == 'empty'

  @isTeacher = ->
    role == 'teacher'

  @isStudent = ->
    role != 'teacher'

  @

eventStatusCtrl.$inject = ['$scope']

eventStatus = ->
  restrict: 'E'
  templateUrl: 'courses/events/event-status'
  controller: eventStatusCtrl
  controllerAs: 'vm'
  scope:
    event: '='
    role: '='

angular
  .module('app.courses')
  .directive('eventStatus', eventStatus)
