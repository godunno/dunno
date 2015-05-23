DunnoApp = angular.module('DunnoApp')

EventCtrl = (
  $scope,
  $routeParams,
  $window,
  $q,
  event,
  Event,
  Utils,
  DateUtils)->

  # TODO: Check if we can use these services directly instead of extending them.
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  initializeEvent = (event)->
    $scope.event = event
    $scope.$broadcast('initializeEvent', event)

  initializeEvent(event)

  # TODO: We may not need to do all this, maybe event.save() already works.
  $scope.save = (event)->
    deferred = $q.defer()
    event.save().then(->
      initializeEvent(event)
      deferred.resolve()
    ).catch(-> deferred.reject())
    deferred.promise

  $scope.courseLocation = (event)->
    return unless event? && event.course?
    "#courses/#{event.course.uuid}?month=#{event.start_at}"

  $scope.finish = (event)->
    unless $scope.$emit('dunno.exit').defaultPrevented
      $scope.save(event).then ->
        $scope.eventForm.$setPristine()
        $window.location.href = $scope.courseLocation(event)

  $scope.publish = (event)->
    event.status = 'published'
    $scope.finish(event)

  # TODO: Extract this somewhere. Can't currently because we can't see this on EventListCtrl
  $scope.showPrivateTopics = true
  $scope.setPrivateTopicsVisibility = (visible)->
    $scope.showPrivateTopics = visible

  $scope.setStatus = (event, status) ->
    return if status == 'canceled' && !confirm('Deseja cancelar esta aula?')
    event.status = status
    $scope.$emit('wholePageLoading', $scope.save(event))

EventCtrl.$inject = ['$scope', '$routeParams', '$window', '$q', 'event', 'Event', 'Utils', 'DateUtils']
DunnoApp.controller 'EventCtrl', EventCtrl
