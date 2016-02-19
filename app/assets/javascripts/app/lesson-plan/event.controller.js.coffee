EventCtrl = (
  $scope,
  $window,
  $q,
  event,
  Event,
  AnalyticsTracker,
  Utils,
  DateUtils,
  ModalFactory
) ->

  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  initializeEvent = (event) ->
    $scope.event = event
    $scope.$broadcast('initializeEvent', event)

  initializeEvent(event)

  $scope.save = (event) ->
    deferred = $q.defer()
    event.save().then(->
      initializeEvent(event)
      deferred.resolve()
    ).catch(-> deferred.reject())
    deferred.promise

  $scope.courseLocation = (event) ->
    return unless event? && event.course?
    "#courses/#{event.course.uuid}?month=#{event.start_at}"

  $scope.showPrivateTopics = true
  $scope.setPrivateTopicsVisibility = (visible) ->
    $scope.showPrivateTopics = visible

  $scope.setStatus = (event, status) ->
    previousStatus = event.status
    message = """
      Deseja cancelar esta aula?

      Atenção: você e seus alunos serão notificados
      por email do cancelamento dessa aula.
    """
    return if status == 'canceled' && !confirm(message)
    event.status = status
    $scope.$emit 'wholePageLoading', event.save().then ->
      AnalyticsTracker.trackEventStatus(event, previousStatus)

  $scope.$on 'transferTopic', (_, topic) ->
    $scope.event.next.topics.push(topic)

  $scope.openEditDates = ->
    new ModalFactory
      templateUrl: 'lesson-plan/dates-edit'
      controller: 'EditEventDatesCtrl as vm'
      class: 'medium event__dates__edit'
      resolve:
        event: -> angular.copy($scope.event)
    .activate()

EventCtrl.$inject = [
  '$scope',
  '$window',
  '$q',
  'event',
  'Event',
  'AnalyticsTracker',
  'Utils',
  'DateUtils',
  'ModalFactory'
]

angular
  .module('app.lessonPlan')
  .controller('EventCtrl', EventCtrl)
