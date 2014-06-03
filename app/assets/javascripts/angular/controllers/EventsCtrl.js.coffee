DunnoApp = angular.module('DunnoApp')

EventCtrl = ($scope, Event, $location, $routeParams, Utils)->
  angular.extend($scope, Utils)
  $scope.event = new Event()
  $scope.event = Event.get(id: $routeParams.id) if $routeParams.id

  $scope.save = (event)->
    promise = if event.id? then event.$update() else event.save()
    promise.then (response)->
      $location.path '#/events'
EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'Utils']
DunnoApp.controller 'EventCtrl', EventCtrl
