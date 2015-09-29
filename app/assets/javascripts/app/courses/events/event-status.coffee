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
    event.status == 'canceled'

  @isPublished = ->
    event.status == 'published'

  @isDraft = ->
    event.status == 'draft'

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
