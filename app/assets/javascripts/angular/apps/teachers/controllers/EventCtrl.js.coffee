DunnoApp = angular.module('DunnoApp')

EventCtrl = (
  $scope,
  $routeParams,
  $window,
  $q,
  Event,
  Utils,
  DateUtils)->

  # TODO: Check if we can use these services directly instead of extending them.
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  # TODO: extract this get -> then -> assign to a service
  $scope.$emit('wholePageLoading', Event.get(uuid: $routeParams.id).then (event)->
    initializeEvent(event)
  )

  initializeEvent = (event)->
    $scope.event = event
    $scope.$broadcast('initializeEvent', event)

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
        $scope.event_form.$setPristine()
        $window.location.href = $scope.courseLocation(event)

  $scope.publish = (event)->
    event.status = 'published'
    $scope.finish(event)

  # TODO: Extract this somewhere. Can't currently because we can't see this on EventListCtrl
  $scope.showPrivateTopics = true
  $scope.setPrivateTopicsVisibility = (visible)->
    $scope.showPrivateTopics = visible

EventCtrl.$inject = ['$scope', '$routeParams', '$window', '$q', 'Event', 'Utils', 'DateUtils']
DunnoApp.controller 'EventCtrl', EventCtrl
